// server/index.js

const express = require('express');
const bodyParser = require('body-parser');
require('dotenv').config();

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

app.post('/api/generate', checkAuth, (req, res) => {
  const { provider, type, payload } = req.body || {};
  if (!provider || !type) return res.status(400).json({ error: 'provider and type required' });

  const jobId = 'job_' + (jobCounter++);
  jobs[jobId] = { id: jobId, provider, type, payload, status: 'queued', createdAt: new Date().toISOString() };

  // Mock processing delay
  setTimeout(() => {
    jobs[jobId].status = 'done';
    // For demo, we produce a mock zip url
    jobs[jobId].result = { zipUrl: `http://localhost:${PORT}/mock/${jobId}.zip` };
  }, 2000);

  return res.json({ ok: true, jobId, status: jobs[jobId].status, result: jobs[jobId].result || null });
});

app.get('/mock/:file', (req, res) => {
  // Return a simple text file as placeholder for ZIP
  const file = req.params.file;
  res.setHeader('Content-Type', 'application/zip');
  res.send(Buffer.from('This is a mock zip for ' + file));
});

app.get('/api/jobs/:id', checkAuth, (req, res) => {
  const id = req.params.id;
  if (!jobs[id]) return res.status(404).json({ error: 'Job not found' });
  return res.json(jobs[id]);
});

app.listen(PORT, () => {
  console.log(`Integration server running on port ${PORT}`);
});
