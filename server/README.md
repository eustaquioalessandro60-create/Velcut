# Server POC for IDM Cifras

This server provides:
- Protected endpoints to store API keys (ADMIN_TOKEN required)
- Job creation endpoint to orchestrate generation (TTS + video creation + transcode + zip)
- Optional upload to S3 if S3_BUCKET and AWS credentials are provided

Environment variables (recommended):
- ADMIN_TOKEN=your_admin_token
- ELEVENLABS_KEY=... (optional)
- ELEVEN_VOICE_ID=... (optional)
- S3_BUCKET=... (optional)
- AWS_ACCESS_KEY_ID=... (optional if uploading)
- AWS_SECRET_ACCESS_KEY=... (optional if uploading)
- AWS_REGION=us-east-1 (optional)

Run locally:
1. cd server
2. npm install
3. ADMIN_TOKEN=seu_token node index.js
4. Use the Flutter frontend pointing to this server (SERVER_BASE)
