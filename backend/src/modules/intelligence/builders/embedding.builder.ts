import { IKnowledgeRecord } from '../../knowledge/model/knowledgeRecord.model';

export class EmbeddingBuilder {
  /**
   * Constructs an optimized, dense semantic text string from a KnowledgeRecord.
   */
  buildInputString(record: IKnowledgeRecord): string {
    const parts: string[] = [];

    parts.push(`Title: ${record.title}`);
    parts.push(`Summary: ${record.summary}`);
    
    if (record.businessContext) {
      parts.push(`Business Context: ${record.businessContext}`);
    }

    if (record.technicalDecisions && record.technicalDecisions.length > 0) {
      parts.push(`Technical Decisions: ${record.technicalDecisions.join('; ')}`);
    }

    if (record.risks && record.risks.length > 0) {
      parts.push(`Risks: ${record.risks.join('; ')}`);
    }

    if (record.breakingChanges && record.breakingChanges.length > 0) {
      parts.push(`Breaking Changes: ${record.breakingChanges.join('; ')}`);
    }

    if (record.dependencies && record.dependencies.length > 0) {
      parts.push(`Dependencies: ${record.dependencies.join('; ')}`);
    }

    if (record.affectedComponents && record.affectedComponents.length > 0) {
      parts.push(`Affected Components: ${record.affectedComponents.join('; ')}`);
    }

    if (record.referencedApis && record.referencedApis.length > 0) {
      parts.push(`Referenced APIs: ${record.referencedApis.join('; ')}`);
    }

    // Join with double newlines for semantic chunking clarity
    return parts.join('\n\n');
  }
}

export const embeddingBuilder = new EmbeddingBuilder();
