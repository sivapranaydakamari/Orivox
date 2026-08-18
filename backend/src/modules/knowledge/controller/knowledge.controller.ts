import { Request, Response } from 'express';
import { knowledgeService } from '../service/knowledge.service';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';

export class KnowledgeController {
  getAll = asyncHandler(async (req: Request, res: Response) => {
    const records = await knowledgeService.getKnowledgeRecords(req.query, req.user!.organizationId);
    ApiResponse.success(res, records, 'Knowledge records retrieved successfully');
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const record = await knowledgeService.getKnowledgeRecordById(req.params.id as string);
    if (!record) {
      return ApiResponse.error(res, 'Knowledge record not found', null, 404);
    }

    await auditService.logAction(req.user!.organizationId, 'KNOWLEDGE_VIEWED', 'KNOWLEDGE_RECORD', record._id.toString(), req.user!.id, record.projectId.toString());

    ApiResponse.success(res, record, 'Knowledge record retrieved successfully');
  });
}

export const knowledgeController = new KnowledgeController();
