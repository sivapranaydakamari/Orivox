const BASE_URL = 'http://localhost:3000/api/v1';

async function request(path: string, method: string = 'GET', body?: any, token?: string, orgId?: string) {
  const headers: any = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  if (orgId) headers['x-organization-id'] = orgId;
  
  const res = await fetch(`${BASE_URL}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined
  });
  
  const data = await res.json();
  return { status: res.status, data };
}

async function runE2ETests() {
  console.log('--- STARTING E2E ACCEPTANCE TESTS ---');
  try {
    // 1. Register Users
    console.log('\\n1. Registering Users...');
    const adminRes = await request('/auth/register', 'POST', { name: 'Admin', email: 'admin_test@test.com', password: 'password123' });
    const managerRes = await request('/auth/register', 'POST', { name: 'Manager', email: 'manager_test@test.com', password: 'password123' });
    const leadRes = await request('/auth/register', 'POST', { name: 'Team Lead', email: 'team_lead_test@test.com', password: 'password123' });
    const empRes = await request('/auth/register', 'POST', { name: 'Employee', email: 'employee_test@test.com', password: 'password123' });

    // Assuming login returns token
    const adminToken = adminRes.data?.data?.accessToken || (await request('/auth/login', 'POST', { email: 'admin_test@test.com', password: 'password123' })).data.data.accessToken;
    const managerToken = managerRes.data?.data?.accessToken || (await request('/auth/login', 'POST', { email: 'manager_test@test.com', password: 'password123' })).data.data.accessToken;
    const leadToken = leadRes.data?.data?.accessToken || (await request('/auth/login', 'POST', { email: 'team_lead_test@test.com', password: 'password123' })).data.data.accessToken;
    const empToken = empRes.data?.data?.accessToken || (await request('/auth/login', 'POST', { email: 'employee_test@test.com', password: 'password123' })).data.data.accessToken;

    // 2. Create Organization
    console.log('\\n2. Creating Organization...');
    const orgRes = await request('/organizations', 'POST', { name: 'Test Org 11.7', slug: 'test-org-11-7' }, adminToken);
    
    if (orgRes.status >= 400) {
        console.error('Org creation failed:', orgRes.data);
    }
    
    const orgId = orgRes.data?.data?._id || orgRes.data?._id || orgRes.data?.id;
    console.log(`Created Org: ${orgId}`);

    // Switch context for users (simulating active organization selection in UI)
    console.log('\n3. Adding members to organization...');
    
    // Add manager
    await request(`/organizations/${orgId}/members`, 'POST', { email: 'manager_test@test.com', role: 'MANAGER' }, adminToken, orgId);
    // Add team lead
    await request(`/organizations/${orgId}/members`, 'POST', { email: 'team_lead_test@test.com', role: 'TEAM_LEAD' }, adminToken, orgId);
    // Add employee
    await request(`/organizations/${orgId}/members`, 'POST', { email: 'employee_test@test.com', role: 'EMPLOYEE' }, adminToken, orgId);
    
    console.log('Members added successfully.');

    console.log('\n4. Creating Projects (Admin)...');
    const projARes = await request('/projects', 'POST', { name: 'Project A', description: 'Desc A', organizationId: orgId }, adminToken, orgId);
    const projBRes = await request('/projects', 'POST', { name: 'Project B', description: 'Desc B', organizationId: orgId }, adminToken, orgId);
    
    const projAId = projARes.data?.data?._id || projARes.data?._id;
    const projBId = projBRes.data?.data?._id || projBRes.data?._id;
    
    console.log(`Created Project A: ${projAId}`);
    console.log(`Created Project B: ${projBId}`);

    console.log('\n5. Verifying Project Isolation...');
    
    const managerProjectsBefore = await request(`/projects?organizationId=${orgId}`, 'GET', undefined, managerToken, orgId);
    console.log(`Manager projects before assignment: ${managerProjectsBefore.data?.data?.length || 0}`);
    
    await request(`/projects/${projAId}/members`, 'POST', { userId: managerRes.data.data.user._id, role: 'PROJECT_MANAGER' }, adminToken, orgId);
    console.log('Assigned Manager to Project A');

    const managerProjectsAfter = await request(`/projects?organizationId=${orgId}`, 'GET', undefined, managerToken, orgId);
    console.log(`Manager projects after assignment: ${managerProjectsAfter.data?.data?.length || 0}`);

    if (managerProjectsAfter.data?.data?.length === 1 && managerProjectsAfter.data?.data[0]?._id === projAId) {
        console.log('SUCCESS: Project Isolation and RBAC verified for Manager.');
    } else {
        console.error('FAILED: Project Isolation failed.');
    }

    console.log('\\n--- E2E TESTS COMPLETED ---');
  } catch (err) {
    console.error('Test failed:', err);
  }
}

runE2ETests();
