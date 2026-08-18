import { IKnowledgeRecord } from '../../knowledge/model/knowledgeRecord.model';
import { IRetrievalEvidence } from '../models/retrieval-evidence.model';

export class RetrievalRanker {
  /**
   * Transforms raw MongoDB Vector Search results into sanitized Evidence Models.
   * Enforces semantic similarity thresholds and sorts.
   */
  rankAndFormat(
    rawResults: (IKnowledgeRecord & { score: number })[],
    minSimilarityScore: number = 0.6
  ): IRetrievalEvidence[] {
    // 1. Filter out results that fall below our confidence threshold
    const confidentResults = rawResults.filter((r) => r.score >= minSimilarityScore);

    // 2. Sort explicitly by score descending (Atlas usually does this natively, but this guarantees ordering)
    const sortedResults = confidentResults.sort((a, b) => b.score - a.score);

    // 3. Deduplicate (if there were overlapping chunks representing the same KnowledgeRecord)
    const uniqueMap = new Map<string, IRetrievalEvidence>();

    for (const record of sortedResults) {
      const idStr = record._id.toString();
      
      if (!uniqueMap.has(idStr)) {
        uniqueMap.set(idStr, {
          knowledgeRecordId: idStr,
          documentId: record.documentId?.toString(),
          similarityScore: record.score,
          summary: record.summary,
          sourceType: record.sourceType.toString(),
          repository: record.metadata?.repository as string | undefined, // Future-proofing
          metadata: record.metadata,
        });
      }
    }

    return Array.from(uniqueMap.values());
  }
}
