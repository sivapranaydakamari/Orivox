import mongoose from 'mongoose';
import { connectDB } from '../src/config/db';
import { userService } from '../src/modules/user/service/user.service';
import { organizationService } from '../src/modules/organization/service/organization.service';
import { projectService } from '../src/modules/project/service/project.service';
import { memberService } from '../src/modules/organization/service/member.service';
import { OrgRole, ProjectRole } from '../src/modules/user/model/user.model';
import { IProject } from '../src/modules/project/model/project.model';
import { logger } from '../src/config/logger';
import { Types } from 'mongoose';

async function verifyE2E() {
  await connectDB();
  logger.info('Connected to DB');

  try {
    // 1. Setup Users
    logger.info('--- 1. Setup Users ---');
    const adminUser = await userService.createUser({ name: 'Admin', email: 'admin_test@test.com', password: 'password123' });
    const managerUser = await userService.createUser({ name: 'Manager', email: 'manager_test@test.com', password: 'password123' });
    const teamLeadUser = await userService.createUser({ name: 'Team Lead', email: 'team_lead_test@test.com', password: 'password123' });
    const employeeUser = await userService.createUser({ name: 'Employee', email: 'employee_test@test.com', password: 'password123' });

    // 2. Org Admin creates Organization
    logger.info('--- 2. Create Organization ---');
    const organization = await organizationService.createOrganization('Test Org 11.7', adminUser._id.toString());
    const orgId = organization._id.toString();

    // Org Admin adds members
    logger.info('--- 3. Add Members to Org ---');
    await memberService.addMember(orgId, managerUser.email, OrgRole.MANAGER);
    await memberService.addMember(orgId, teamLeadUser.email, OrgRole.TEAM_LEAD);
    await memberService.addMember(orgId, employeeUser.email, OrgRole.EMPLOYEE);

    const members = await memberService.getMembers(orgId);
    if (members.length !== 4) throw new Error(`Expected 4 members, got ${members.length}`);
    logger.info('Org member assertions passed');

    // 4. Project Creation (Org Admin)
    logger.info('--- 4. Create Projects ---');
    const projectA = await projectService.createProject(orgId, 'Project A', 'Desc A');
    const projectB = await projectService.createProject(orgId, 'Project B', 'Desc B');
    
    // Org Admin has access to all projects
    const adminProjects = await projectService.getProjects(orgId, adminUser._id.toString());
    if (adminProjects.length !== 2) throw new Error('Admin should see 2 projects');

    // Manager initially sees 0 projects
    let managerProjects = await projectService.getProjects(orgId, managerUser._id.toString());
    if (managerProjects.length !== 0) throw new Error(`Manager should see 0 projects, got ${managerProjects.length}`);

    // Assign Manager to Project A
    logger.info('--- 5. Assign Manager to Project A ---');
    await projectService.addProjectMember(projectA._id.toString(), managerUser._id.toString(), ProjectRole.PROJECT_MANAGER);
    
    managerProjects = await projectService.getProjects(orgId, managerUser._id.toString());
    if (managerProjects.length !== 1 || managerProjects[0]._id.toString() !== projectA._id.toString()) {
      throw new Error('Manager should see exactly 1 project (Project A)');
    }
    logger.info('Project isolation for Manager passed');

    // 6. Cross-Organization Isolation
    logger.info('--- 6. Cross-Organization Isolation ---');
    const adminUser2 = await userService.createUser({ name: 'Admin 2', email: 'admin_test2@test.com', password: 'password123' });
    const org2 = await organizationService.createOrganization('Other Org', adminUser2._id.toString());
    
    // adminUser2 tries to get members of orgId
    const isMemberOrg1 = await userService.isMemberOfOrganization(adminUser2._id.toString(), orgId);
    if (isMemberOrg1) throw new Error('adminUser2 should not be member of org1');
    logger.info('Cross-org isolation passed');

    logger.info('--- E2E VERIFICATION PASSED ---');
  } catch (error) {
    logger.error({ error }, 'E2E VERIFICATION FAILED');
  } finally {
    // Cleanup DB (ideally drop the test db, but we can just exit)
    await mongoose.connection.db?.dropDatabase();
    await mongoose.disconnect();
    process.exit(0);
  }
}

verifyE2E();
