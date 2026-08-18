export interface IRetrievalEvidence {
  knowledgeRecordId: string;
  documentId?: string;
  similarityScore: number;
  summary: string;
  sourceType: string;
  repository?: string;
  metadata?: Record<string, unknown>;
}
