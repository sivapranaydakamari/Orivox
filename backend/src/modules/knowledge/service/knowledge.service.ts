import { knowledgeRecordRepository } from '../repository/knowledgeRecord.repository';
import { GetKnowledgeQueryDto } from '../dto/knowledge.dto';
import { IKnowledgeRecord } from '../model/knowledgeRecord.model';

export class KnowledgeService {
  async getKnowledgeRecords(query: GetKnowledgeQueryDto, organizationId: string): Promise<IKnowledgeRecord[]> {
    const filter: Record<string, unknown> = { organizationId };
    if (query.projectId) {
      filter.projectId = query.projectId;
    }
    if (query.sourceType) {
      filter.sourceType = query.sourceType;
    }
    if (query.confidence) {
      filter.confidence = query.confidence;
    }
    if (query.status) {
      filter.embeddingStatus = query.status;
    }
    if (query.repositoryId) {
      // Assuming repositoryId is stored in metadata if applicable
      filter['metadata.repositoryId'] = query.repositoryId;
    }
    return knowledgeRecordRepository.findMany(filter);
  }

  async getKnowledgeRecordById(id: string): Promise<IKnowledgeRecord | null> {
    return knowledgeRecordRepository.findById(id);
  }
}

export const knowledgeService = new KnowledgeService();
