const http = require('http');

function request(method, path, body = null, token = null, orgContext = null) {
  return new Promise((resolve, reject) => {
    const data = body ? JSON.stringify(body) : '';
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
      },
    };

    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }
    if (orgContext) {
      options.headers['x-organization-id'] = orgContext;
    }

    const req = http.request(options, (res) => {
      let resBody = '';
      res.on('data', (chunk) => {
        resBody += chunk;
      });
      res.on('end', () => {
        try {
          const parsed = resBody ? JSON.parse(resBody) : {};
          resolve({ status: res.statusCode, body: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, body: resBody });
        }
      });
    });

    req.on('error', (e) => {
      reject(e);
    });

    if (data) {
      req.write(data);
    }
    req.end();
  });
}

async function runTests() {
  console.log('--- Phase 1: Authentication & Setup ---');
  
  const email = `test-${Date.now()}@example.com`;
  const password = 'Password123!';
  
  await request('POST', '/api/v1/auth/register', { email, password, name: 'Test User' });
  const loginRes = await request('POST', '/api/v1/auth/login', { email, password });
  const token = loginRes.body.data.accessToken;

  const orgRes = await request('POST', '/api/v1/organizations', {
    name: 'Test Organization ' + Date.now(),
    slug: 'test-org-' + Date.now()
  }, token);
  const orgId = orgRes.body.data._id;

  const projRes = await request('POST', '/api/v1/projects', {
    name: 'Test Project',
    description: 'A test project'
  }, token, orgId);
  const projectId = projRes.body.data._id;

  const repoRes = await request('POST', '/api/v1/repositories', {
    projectId: projectId,
    repositoryName: 'expressjs/express',
    repositoryUrl: 'https://github.com/expressjs/express'
  }, token, orgId);
  const repoId = repoRes.body.data._id;

  console.log('Waiting for repository sync to complete...');
  let repoStatus = 'PENDING';
  while (repoStatus === 'PENDING' || repoStatus === 'SYNCING') {
    await new Promise(resolve => setTimeout(resolve, 2000));
    const repoCheck = await request('GET', `/api/v1/repositories/${repoId}`, null, token, orgId);
    repoStatus = repoCheck.body.data.syncStatus;
    console.log(`Sync status: ${repoStatus}`);
  }

  console.log('Waiting 30 seconds for extraction and embedding to finish...');
  await new Promise(resolve => setTimeout(resolve, 30000));

  console.log('--- Phase 2: RAG Pipeline Test ---');
  
  const question = "How does res.send handle raw ArrayBuffer now, and what was the previous behavior?";
  console.log('Sending Question:', question);
  
  const startTime = Date.now();
  const askRes = await request('POST', '/api/v1/ask', {
    projectId,
    question
  }, token, orgId);
  const duration = Date.now() - startTime;
  
  console.log('Response Time:', duration, 'ms');
  console.log('Response Status:', askRes.status);
  console.log(JSON.stringify(askRes.body, null, 2));

  console.log('End to End test successful!');
}

runTests().catch(console.error);
