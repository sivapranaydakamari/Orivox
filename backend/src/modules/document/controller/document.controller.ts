import { Request, Response } from 'express';
import { documentService } from '../service/document.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { userRepository } from '../../user/repository/user.repository';
import { OrgRole } from '../../user/model/user.model';

export class DocumentController {
  getAll = asyncHandler(async (req: Request, res: Response) => {
    const user = await userRepository.findById(req.user!.id);
    if (!user) return ApiResponse.error(res, 'User not found', null, 401);
    
    const orgMembership = user.memberships.find(m => m.organizationId.toString() === req.user!.organizationId);
    if (!orgMembership) return ApiResponse.error(res, 'Access denied', null, 403);

    const documents = await documentService.getDocuments(req.query, req.user!.organizationId);
    
    let filteredDocs = documents;
    if (orgMembership.orgRole !== OrgRole.ORG_ADMIN) {
      const allowedProjectIds = orgMembership.projectRoles.map(p => p.projectId.toString());
      filteredDocs = documents.filter(doc => allowedProjectIds.includes(doc.projectId.toString()));
    }
    
    ApiResponse.success(res, filteredDocs, 'Documents retrieved successfully');
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const document = await documentService.getDocumentById(req.params.id as string);
    if (!document) {
      return ApiResponse.error(res, 'Document not found', null, 404);
    }
    ApiResponse.success(res, document, 'Document retrieved successfully');
  });

  create = asyncHandler(async (req: Request, res: Response) => {
    const { title, content, projectId } = req.body;
    const document = await documentService.createDocument({
      organizationId: req.user!.organizationId as any,
      projectId: projectId as any,
      sourceType: 'MANUAL' as any,
      externalId: `doc_${Date.now()}`,
      title: title || 'Custom Engineering Document',
      rawContent: content || '',
      status: 'PENDING' as any,
    });
    ApiResponse.success(res, document, 'Document created successfully', 201);
  });

  ingestPostman = asyncHandler(async (req: Request, res: Response) => {
    const { collectionJson, projectId } = req.body;
    
    if (!collectionJson || !projectId) {
      return ApiResponse.error(res, 'collectionJson and projectId are required', null, 400);
    }

    const { postmanIngestionService } = await import('../../integration/services/postman-ingestion.service');
    
    const document = await postmanIngestionService.ingestCollection(
      projectId,
      req.user!.organizationId,
      collectionJson,
      req.user!.id
    );

    ApiResponse.success(res, document, 'Postman collection ingested successfully', 201);
  });
}

export const documentController = new DocumentController();
