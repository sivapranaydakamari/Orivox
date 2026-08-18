import { IRetrievalEvidence } from '../../retrieval/models/retrieval-evidence.model';

export class CitationBuilder {
  /**
   * Every answer should include references.
   * Example Source: Repository, Pull Request, Document, KnowledgeRecord, Similarity Score.
   */
  public build(evidenceList: IRetrievalEvidence[]): string[] {
    if (!evidenceList || evidenceList.length === 0) {
      return [];
    }

    // Merge duplicate evidence (same logic as ContextBuilder to ensure source numbers match)
    const uniqueEvidenceMap = new Map<string, IRetrievalEvidence>();
    for (const evidence of evidenceList) {
      const uniqueKey = evidence.documentId || evidence.knowledgeRecordId;
      if (!uniqueEvidenceMap.has(uniqueKey)) {
        uniqueEvidenceMap.set(uniqueKey, evidence);
      } else {
        const existing = uniqueEvidenceMap.get(uniqueKey)!;
        if (evidence.similarityScore > existing.similarityScore) {
          uniqueEvidenceMap.set(uniqueKey, evidence);
        }
      }
    }

    const sortedEvidence = Array.from(uniqueEvidenceMap.values()).sort(
      (a, b) => b.similarityScore - a.similarityScore
    );

    const citations: string[] = [];
    
    for (let i = 0; i < sortedEvidence.length; i++) {
      const evidence = sortedEvidence[i];
      const sourceId = evidence.documentId || evidence.knowledgeRecordId;
      const roundedScore = (evidence.similarityScore * 100).toFixed(2);
      
      const citation = `[Source ${i + 1}] ${evidence.sourceType} - ${evidence.repository ? evidence.repository : 'Unknown Repo'} (ID: ${sourceId}) - Relevance: ${roundedScore}%`;
      citations.push(citation);
    }

    return citations;
  }
}
