const http = require('http');

async function makeRequest(method, path, body = null, token = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: '/api/v1' + path,
      method: method,
      headers: {
        'Content-Type': 'application/json'
      }
    };
    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch(e) {
          resolve({ status: res.statusCode, body: data });
        }
      });
    });
    req.on('error', reject);
    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function run() {
  try {
    const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTdiNDZlZDk5ZmYxODRkMmM2ODQwMjUiLCJvcmdhbml6YXRpb25JZCI6IjZhN2I0ZDM1ZjgxMjliOTQ4YzlkYWJjOCIsInNlc3Npb25JZCI6IjEyMyIsImlhdCI6MTc4NjQ2NzU0NH0.GIFZwkt4dc4ft70prsQxG0RmDs5TwO7lRqXY52o7bxQ';
    const projectId = '6a7b4d35f8129b948c9dabc9';
    const question = 'Why was a missing semicolon added in lib/express.js?';
    
    console.log('Sending Question:', question);
    const startTime = Date.now();
    const askRes = await makeRequest('POST', '/ask', {
      projectId,
      question
    }, token);
    const duration = Date.now() - startTime;
    
    console.log('Response Time:', duration, 'ms');
    console.log('Response Status:', askRes.status);
    console.log(JSON.stringify(askRes.body, null, 2));

  } catch(e) {
    console.error('Error:', e);
  }
}
run();
