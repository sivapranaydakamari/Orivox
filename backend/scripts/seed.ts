import mongoose, { Types } from 'mongoose';
import { env } from '../src/config/env';
import { Organization } from '../src/modules/organization/model/organization.model';
import { Project } from '../src/modules/project/model/project.model';
import { Repository } from '../src/modules/repository/model/repository.model';
import { User, AuthProvider, GlobalRole, OrgRole, ProjectRole } from '../src/modules/user/model/user.model';
import { DocumentModel, DocumentSourceType, DocumentStatus } from '../src/modules/document/model/document.model';
import { KnowledgeRecord, SourceType, ConfidenceLevel } from '../src/modules/knowledge/model/knowledgeRecord.model';
import { logger } from '../src/config/logger';

const seedDatabase = async () => {
  try {
    logger.info('Connecting to database...');
    await mongoose.connect(env.MONGO_URI);
    logger.info('Connected.');

    logger.info('Wiping existing data...');
    await Promise.all([
      Organization.deleteMany({}),
      Project.deleteMany({}),
      Repository.deleteMany({}),
      User.deleteMany({}),
      DocumentModel.deleteMany({}),
      KnowledgeRecord.deleteMany({}),
    ]);
    logger.info('Database wiped.');

    // 1. Create Organization
    const org = await Organization.create({
      name: 'Acme Corp Engineering',
      slug: 'acme-corp',
    });

    // 2. Create Users
    const orgAdmin = await User.create({
      name: 'Alice Admin',
      email: 'alice@acmecorp.com',
      authProvider: AuthProvider.GITHUB,
      globalRole: GlobalRole.PLATFORM_OWNER,
      memberships: [
        {
          organizationId: org._id,
          orgRole: OrgRole.ORG_ADMIN,
          projectRoles: [], // Will populate later
        },
      ],
    });

    const projectManager = await User.create({
      name: 'Bob Manager',
      email: 'bob@acmecorp.com',
      authProvider: AuthProvider.EMAIL,
      globalRole: GlobalRole.USER,
      memberships: [
        {
          organizationId: org._id,
          orgRole: OrgRole.MEMBER,
          projectRoles: [],
        },
      ],
    });

    const engineer = await User.create({
      name: 'Charlie Engineer',
      email: 'charlie@acmecorp.com',
      authProvider: AuthProvider.GITHUB,
      globalRole: GlobalRole.USER,
      memberships: [
        {
          organizationId: org._id,
          orgRole: OrgRole.MEMBER,
          projectRoles: [],
        },
      ],
    });

    // Update Audit Fields on Org
    org.createdBy = orgAdmin._id as Types.ObjectId;
    await org.save();

    // 3. Create Projects
    const backendProject = await Project.create({
      organizationId: org._id,
      name: 'Backend Microservices',
      description: 'Core backend architecture',
      createdBy: orgAdmin._id,
    });

    const mobileProject = await Project.create({
      organizationId: org._id,
      name: 'Mobile App',
      description: 'iOS and Android app development',
      createdBy: orgAdmin._id,
    });

    // 4. Update User Memberships with Projects
    orgAdmin.memberships[0].projectRoles.push(
      { projectId: backendProject._id as Types.ObjectId, role: ProjectRole.PROJECT_ADMIN },
      { projectId: mobileProject._id as Types.ObjectId, role: ProjectRole.PROJECT_ADMIN }
    );
    await orgAdmin.save();

    projectManager.memberships[0].projectRoles.push(
      { projectId: backendProject._id as Types.ObjectId, role: ProjectRole.PROJECT_ADMIN }
    );
    await projectManager.save();

    engineer.memberships[0].projectRoles.push(
      { projectId: backendProject._id as Types.ObjectId, role: ProjectRole.ENGINEER },
      { projectId: mobileProject._id as Types.ObjectId, role: ProjectRole.ENGINEER }
    );
    await engineer.save();

    // 5. Create Repositories
    const backendRepo = await Repository.create({
      organizationId: org._id,
      projectId: backendProject._id,
      provider: 'GITHUB',
      repositoryUrl: 'https://github.com/acmecorp/backend-services',
      repositoryName: 'backend-services',
      createdBy: orgAdmin._id,
    });

    const mobileRepo = await Repository.create({
      organizationId: org._id,
      projectId: mobileProject._id,
      provider: 'GITHUB',
      repositoryUrl: 'https://github.com/acmecorp/mobile-app',
      repositoryName: 'mobile-app',
      createdBy: orgAdmin._id,
    });

    // 6. Create Documents
    const doc1 = await DocumentModel.create({
      organizationId: org._id,
      projectId: backendProject._id,
      sourceType: DocumentSourceType.MARKDOWN,
      title: 'Authentication Architecture',
      rawContent: '# Auth\nUsing JWTs and Redis for session management.',
      status: DocumentStatus.EXTRACTED,
      uploadedBy: engineer._id,
      createdBy: engineer._id,
    });

    const doc2 = await DocumentModel.create({
      organizationId: org._id,
      projectId: backendProject._id,
      sourceType: DocumentSourceType.DECISION_LOG,
      title: 'Move to PostgreSQL',
      rawContent: 'Decided to move from MySQL to PostgreSQL for better JSON support.',
      status: DocumentStatus.EXTRACTED,
      uploadedBy: projectManager._id,
      createdBy: projectManager._id,
    });

    const doc3 = await DocumentModel.create({
      organizationId: org._id,
      projectId: mobileProject._id,
      sourceType: DocumentSourceType.GITHUB,
      title: 'PR #102: Implement offline mode',
      rawContent: 'Added SQLite local cache for offline viewing.',
      status: DocumentStatus.EXTRACTED,
      uploadedBy: engineer._id,
      createdBy: engineer._id,
    });

    const doc4 = await DocumentModel.create({
      organizationId: org._id,
      projectId: backendProject._id,
      sourceType: DocumentSourceType.POSTMAN,
      title: 'Core API Collection',
      rawContent: '{"info": {"name": "Core API", "schema": "..."}}',
      status: DocumentStatus.EXTRACTED,
      uploadedBy: engineer._id,
      createdBy: engineer._id,
    });

    const doc5 = await DocumentModel.create({
      organizationId: org._id,
      projectId: mobileProject._id,
      sourceType: DocumentSourceType.DECISION_LOG,
      title: 'React Native over Flutter',
      rawContent: 'Selected React Native due to team familiarity with React.',
      status: DocumentStatus.EXTRACTED,
      uploadedBy: projectManager._id,
      createdBy: projectManager._id,
    });

    // 7. Create Knowledge Records
    const fakeEmbedding = new Array(1024).fill(0).map(() => Math.random());

    const krBase = {
      organizationId: org._id,
      confidence: ConfidenceLevel.HIGH,
      embedding: fakeEmbedding,
      embeddingModel: 'mistral-embed',
      embeddingCreatedAt: new Date(),
      knowledgeVersion: 1,
    };

    const records = [
      {
        ...krBase,
        projectId: backendProject._id,
        sourceType: SourceType.MARKDOWN,
        sourceReferenceId: doc1._id,
        documentId: doc1._id,
        title: 'Authentication Implementation',
        summary: 'Backend uses JWT combined with Redis for secure session caching.',
        engineeringReasoning: 'Redis provides fast read/write for session invalidation.',
        affectedComponents: ['AuthModule', 'RedisService'],
        author: 'Charlie Engineer',
        tags: ['auth', 'security', 'redis'],
        metadata: { fileName: 'auth-architecture.md', folderPath: '/docs/architecture' },
        createdBy: engineer._id,
      },
      {
        ...krBase,
        projectId: backendProject._id,
        sourceType: SourceType.DECISION_LOG,
        sourceReferenceId: doc2._id,
        documentId: doc2._id,
        title: 'Database Migration to PostgreSQL',
        summary: 'Transitioned relational data store to PostgreSQL.',
        engineeringReasoning: 'Native JSONB support improves metadata handling significantly.',
        affectedComponents: ['Database Module'],
        author: 'Bob Manager',
        tags: ['database', 'migration', 'postgresql'],
        metadata: { decisionId: 'DEC-042' },
        createdBy: projectManager._id,
      },
      {
        ...krBase,
        projectId: mobileProject._id,
        sourceType: SourceType.GITHUB_PR,
        sourceReferenceId: doc3._id,
        documentId: doc3._id,
        title: 'Mobile Offline Caching',
        summary: 'Implemented local SQLite database to persist data when network drops.',
        engineeringReasoning: 'Improves UX in low-connectivity areas.',
        affectedComponents: ['NetworkInterceptor', 'SQLiteStore'],
        author: 'Charlie Engineer',
        tags: ['mobile', 'offline', 'sqlite'],
        metadata: { prNumber: 102, branch: 'feat/offline', commitSha: 'a1b2c3d4' },
        createdBy: engineer._id,
      },
      {
        ...krBase,
        projectId: backendProject._id,
        sourceType: SourceType.POSTMAN,
        sourceReferenceId: doc4._id,
        documentId: doc4._id,
        title: 'REST API Collection',
        summary: 'Defines the Core REST API contracts.',
        affectedComponents: ['API Gateway'],
        tags: ['api', 'postman', 'contracts'],
        metadata: { collectionName: 'Core API', endpointCount: 45 },
        createdBy: engineer._id,
      },
      {
        ...krBase,
        projectId: mobileProject._id,
        sourceType: SourceType.DECISION_LOG,
        sourceReferenceId: doc5._id,
        documentId: doc5._id,
        title: 'Mobile Framework Selection',
        summary: 'React Native chosen as the primary mobile framework.',
        engineeringReasoning: 'Leverages existing web team React expertise to accelerate delivery.',
        affectedComponents: ['Mobile App Core'],
        tags: ['framework', 'decision', 'react-native'],
        createdBy: projectManager._id,
      }
    ];

    // Duplicate 5 more to reach 10
    for(let i=0; i<5; i++) {
      records.push({
        ...records[i],
        title: `${records[i].title} (Part 2)`,
        summary: `Extended details for ${records[i].title}`,
      });
    }

    await KnowledgeRecord.insertMany(records);

    logger.info('Database seeded successfully!');
    process.exit(0);
  } catch (error) {
    logger.error({ error }, 'Error seeding database');
    process.exit(1);
  }
};

seedDatabase();
