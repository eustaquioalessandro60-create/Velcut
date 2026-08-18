const express = require('express');
const bodyParser = require('body-parser');
require('dotenv').config();
const fs = require('fs');
const os = require('os');
const path = require('path');
const { exec } = require('child_process');
const archiver = require('archiver');
const { v4: uuidv4 } = require('uuid');
const AWS = require('aws-sdk');

const app = express();
const PORT = process.env.PORT || 4000;
const ADMIN_TOKEN = process.env.ADMIN_TOKEN || 'changeme_admin_token';

app.use(bodyParser.json());

// Simple in-memory store (for POC) - DON'T use in production
const store = { keys: {} };
let jobCounter = 1;
const jobs = {};

function checkAuth(req, res, next) {
  const header = req.headers['authorization'] || '';
  if (!header.startsWith('Bearer ')) return res.status(401).json({ error: 'Missing token' });
  const token = header.split(' ')[1];
  if (token !== ADMIN_TOKEN) return res.status(403).json({ error: 'Invalid token' });
  next();
}

app.post('/api/keys', checkAuth, (req, res) => {
  const { provider, key } = req.body || {};
  if (!provider || !key) return res.status(400).json({ error: 'provider and key required' });
  // store in memory and process.env for demonstration
  store.keys[provider] = key;
  process.env[provider.toUpperCase() + '_KEY'] = key;
  return res.json({ ok: true });
});

app.get('/api/keys', checkAuth, (req, res) => {
  return res.json(store.keys);
});

app.post('/api/generate', checkAuth, async (req, res) => {
  const { provider, type, payload } = req.body || {};
  if (!provider || !type) return res.status(400).json({ error: 'provider and type required' });

  const jobId = 'job_' + (jobCounter++);
  jobs[jobId] = { id: jobId, provider, type, payload, status: 'queued', createdAt: new Date().toISOString() };

  // Asynchronously process the job
  processJob(jobId).catch(err => {
    console.error('Job processing error:', err);
    if (jobs[jobId]) jobs[jobId].status = 'error';
  });

  return res.json({ ok: true, jobId, status: jobs[jobId].status, result: jobs[jobId].result || null });
});

app.get('/api/jobs/:id', checkAuth, (req, res) => {
  const id = req.params.id;
  if (!jobs[id]) return res.status(404).json({ error: 'Job not found' });
  return res.json(jobs[id]);
});

app.get('/results/:jobId', (req, res) => {
  const jobId = req.params.jobId;
  const job = jobs[jobId];
  if (!job || !job.result || !job.result.zipPath) return res.status(404).send('Result not found');

  const zipPath = job.result.zipPath;
  res.download(zipPath, path.basename(zipPath), err => {
    if (err) console.error('Download error', err);
  });
});

async function processJob(jobId) {
  const job = jobs[jobId];
  if (!job) throw new Error('Job not found');
  jobs[jobId].status = 'processing';

  const payload = job.payload || {};
  const title = payload.title || 'Untitled';
  const script = payload.script || 'Sem script';
  const formats = payload.formats || ['YouTube 16:9', 'TikTok 9:16'];

  // Create temporary workdir
  const workDir = fs.mkdtempSync(path.join(os.tmpdir(), `job_${jobId}_`));
  console.log('Workdir:', workDir);

  try {
    // 1) Generate TTS audio (ElevenLabs if key provided)
    const audioPath = path.join(workDir, 'audio.mp3');
    const elevenKey = process.env.ELEVENLABS_KEY || store.keys['elevenlabs'];
    if (elevenKey) {
      console.log('Generating TTS with ElevenLabs');
      await generateElevenLabsTTS(script, audioPath, elevenKey);
    } else {
      console.log('No ElevenLabs key, generating silent audio (3s)');
      await generateSilentAudio(audioPath, 3);
    }

    // 2) Create a placeholder image with title
    const imagePath = path.join(workDir, 'image.png');
    await generatePlaceholderImage(title, imagePath);

    // 3) Create base video (16:9) using ffmpeg: loop image + audio
    const baseVideo = path.join(workDir, 'base_16x9.mp4');
    await createVideoFromImageAndAudio(imagePath, audioPath, baseVideo, 1920, 1080);

    // 4) For each format transcode/scale
    const outputs = [];
    for (const fmt of formats) {
      const safeName = fmt.replace(/[^a-zA-Z0-9]/g, '_');
      let w = 1920, h = 1080;
      if (fmt.includes('9:16') || fmt.toLowerCase().includes('tiktok') || fmt.toLowerCase().includes('kwai') || fmt.toLowerCase().includes('reels')) {
        w = 1080; h = 1920;
      } else if (fmt.includes('1:1') || fmt.toLowerCase().includes('instagram 1:1')) {
        w = 1080; h = 1080;
      } else {
        w = 1920; h = 1080;
      }
      const outPath = path.join(workDir, `out_${safeName}.mp4`);
      await transcodeToResolution(baseVideo, outPath, w, h);
      outputs.push({ fmt, path: outPath });
    }

    // 5) Create PDF cover for job
    const pdfPath = path.join(workDir, 'job_info.pdf');
    await createJobPdf(title, script, jobId, pdfPath);

    // 6) Zip everything
    const zipPath = path.join(workDir, `job_${jobId}_outputs.zip`);
    await createZip(outputs, pdfPath, zipPath);

    // 7) Upload to S3 if configured
    const s3Bucket = process.env.S3_BUCKET;
    if (s3Bucket && process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) {
      const s3Url = await uploadToS3(zipPath, s3Bucket);
      jobs[jobId].result = { zipUrl: s3Url };
      jobs[jobId].status = 'done';
      // cleanup optional
    } else {
      // Serve locally via /results/:jobId
      jobs[jobId].result = { zipPath: zipPath, zipUrl: `http://localhost:${PORT}/results/${jobId}` };
      jobs[jobId].status = 'done';
    }

    console.log('Job completed', jobId);
  } catch (err) {
    console.error('Processing error for job', jobId, err);
    jobs[jobId].status = 'error';
    jobs[jobId].error = String(err);
  }
}

function runCmd(cmd, opts = {}) {
  return new Promise((resolve, reject) => {
    console.log('Running cmd:', cmd);
    exec(cmd, opts, (err, stdout, stderr) => {
      if (err) {
        console.error('Cmd error', err, stderr);
        return reject(err);
      }
      resolve({ stdout, stderr });
    });
  });
}

async function generateElevenLabsTTS(text, outPath, apiKey) {
  // Uses ElevenLabs Text-to-Speech API v1
  // Requires voiceId in ELEVEN_VOICE_ID env or fallback to a default
  const fetch = global.fetch || require('node-fetch');
  const voiceId = process.env.ELEVEN_VOICE_ID || '21m00Tcm4TlvDq8ikWAM'; // placeholder voice id
  const url = `https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'audio/mpeg',
      'Content-Type': 'application/json',
      'xi-api-key': apiKey,
    },
    body: JSON.stringify({ text }),
  });
  if (!res.ok) {
    const txt = await res.text();
    throw new Error('ElevenLabs TTS failed: ' + txt);
  }
  const arrayBuffer = await res.arrayBuffer();
  const buffer = Buffer.from(arrayBuffer);
  fs.writeFileSync(outPath, buffer);
  console.log('TTS saved to', outPath);
}

async function generateSilentAudio(outPath, seconds = 3) {
  // ffmpeg -f lavfi -i anullsrc -t 3 -q:a 9 -acodec libmp3lame out.mp3
  const cmd = `ffmpeg -y -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t ${seconds} -q:a 9 -acodec libmp3lame "${outPath}"`;
  await runCmd(cmd);
}

async function generatePlaceholderImage(title, outPath) {
  // Create a simple PNG using ffmpeg drawtext (requires ffmpeg with libfreetype)
  const cmd = `ffmpeg -y -f lavfi -i color=c=0x0A1122:s=1920x1080 -vf "drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='${escapeFftext(title)}':fontcolor=#D4AF37:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2" -frames:v 1 "${outPath}"`;
  await runCmd(cmd);
}

function escapeFftext(s) {
  return s.replace(/:/g, '\\:').replace(/'/g, "\\'");
}

async function createVideoFromImageAndAudio(imagePath, audioPath, outPath, w = 1920, h = 1080) {
  // ffmpeg looping image to match audio duration
  // ffmpeg -loop 1 -i image.png -i audio.mp3 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest out.mp4
  const cmd = `ffmpeg -y -loop 1 -i "${imagePath}" -i "${audioPath}" -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest -vf "scale=${w}:${h}:force_original_aspect_ratio=decrease,pad=${w}:${h}:(ow-iw)/2:(oh-ih)/2" "${outPath}"`;
  await runCmd(cmd);
}

async function transcodeToResolution(inPath, outPath, w, h) {
  // scale/pad to target
  const cmd = `ffmpeg -y -i "${inPath}" -c:v libx264 -crf 23 -preset veryfast -c:a aac -b:a 128k -vf "scale=${w}:${h}:force_original_aspect_ratio=decrease,pad=${w}:${h}:(ow-iw)/2:(oh-ih)/2" "${outPath}"`;
  await runCmd(cmd);
}

async function createJobPdf(title, script, jobId, pdfPath) {
  // Use wkhtmltopdf or headless chrome would be more complex; for POC create a simple PDF using imagemagick convert via ffmpeg (drawtext) not ideal.
  // We'll create a PNG and convert to PDF using ffmpeg
  const png = pdfPath.replace(/\.pdf$/, '.png');
  const text = `Job: ${jobId}\nTitle: ${title}\nScript:\n${script}`.replace(/\n/g, '\\n');
  const cmdPng = `ffmpeg -y -f lavfi -i color=c=0x0A1122:s=1200x1600 -vf "drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='${escapeFftext(text)}':fontcolor=#D4AF37:fontsize=20:x=30:y=30:box=1:boxcolor=0x00000099" -frames:v 1 "${png}"`;
  await runCmd(cmdPng);
  const cmdPdf = `ffmpeg -y -i "${png}" "${pdfPath}"`;
  await runCmd(cmdPdf);
}

async function createZip(outputs, pdfPath, zipPath) {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(zipPath);
    const archive = archiver('zip', { zlib: { level: 9 } });

    output.on('close', function () {
      console.log(archive.pointer() + ' total bytes');
      resolve();
    });
    archive.on('error', function (err) {
      reject(err);
    });

    archive.pipe(output);
    for (const o of outputs) {
      archive.file(o.path, { name: path.basename(o.path) });
    }
    if (fs.existsSync(pdfPath)) archive.file(pdfPath, { name: path.basename(pdfPath) });
    archive.finalize();
  });
}

async function uploadToS3(filePath, bucket) {
  const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: process.env.AWS_REGION || 'us-east-1',
  });
  const fileStream = fs.createReadStream(filePath);
  const key = `idm_outputs/${path.basename(filePath)}`;
  const params = { Bucket: bucket, Key: key, Body: fileStream, ACL: 'public-read' };
  const data = await s3.upload(params).promise();
  return data.Location;
}

app.listen(PORT, () => {
  console.log(`Integration server running on port ${PORT}`);
});
