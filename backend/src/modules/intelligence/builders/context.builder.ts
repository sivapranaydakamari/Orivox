import { IRetrievalEvidence } from '../../retrieval/models/retrieval-evidence.model';

export class ContextBuilder {
  private static readonly MAX_CONTEXT_LENGTH = 15000;

  /**
   * Accepts RetrievalEvidence.
   * Merges duplicate evidence.
   * Removes irrelevant metadata.
   * Respects token limits.
   * Produces ordered engineering context.
   */
  public build(evidenceList: IRetrievalEvidence[]): string {
    if (!evidenceList || evidenceList.length === 0) {
      return '';
    }

    // Merge duplicate evidence
    const uniqueEvidenceMap = new Map<string, IRetrievalEvidence>();
    for (const evidence of evidenceList) {
      // Use documentId if available, otherwise knowledgeRecordId
      const uniqueKey = evidence.documentId || evidence.knowledgeRecordId;
      if (!uniqueEvidenceMap.has(uniqueKey)) {
        uniqueEvidenceMap.set(uniqueKey, evidence);
      } else {
        // If it already exists, keep the one with higher similarity score
        const existing = uniqueEvidenceMap.get(uniqueKey)!;
        if (evidence.similarityScore > existing.similarityScore) {
          uniqueEvidenceMap.set(uniqueKey, evidence);
        }
      }
    }

    // Sort by similarity score descending (to produce ordered context)
    const sortedEvidence = Array.from(uniqueEvidenceMap.values()).sort(
      (a, b) => b.similarityScore - a.similarityScore
    );

    // Build context string respecting length limit
    let contextString = '';
    
    for (let i = 0; i < sortedEvidence.length; i++) {
      const evidence = sortedEvidence[i];
      const sourceId = evidence.documentId || evidence.knowledgeRecordId;
      
      const snippet = `[Source ${i + 1}]
Source Type: ${evidence.sourceType}
Repository: ${evidence.repository || 'N/A'}
ID: ${sourceId}
Content:
${evidence.summary}

`;

      // Check if adding this snippet would exceed the max length
      if (contextString.length + snippet.length > ContextBuilder.MAX_CONTEXT_LENGTH) {
        // Truncate the snippet to fit if it's the first one, or just break
        if (contextString.length === 0) {
          const availableSpace = ContextBuilder.MAX_CONTEXT_LENGTH - contextString.length;
          contextString += snippet.substring(0, availableSpace) + '...';
        }
        break;
      }
      
      contextString += snippet;
    }

    return contextString.trim();
  }
}
