import { BaseRepository } from '../../../shared/repository/base.repository';
import { IKnowledgeRecord, KnowledgeRecord } from '../model/knowledgeRecord.model';

export class KnowledgeRecordRepository extends BaseRepository<IKnowledgeRecord> {
  constructor() {
    super(KnowledgeRecord);
  }
}

export const knowledgeRecordRepository = new KnowledgeRecordRepository();
