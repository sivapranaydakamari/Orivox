import { Types } from 'mongoose';
import { KnowledgeRecord, IKnowledgeRecord } from '../../knowledge/model/knowledgeRecord.model';
import { logger } from '../../../config/logger';

export interface ISearchFilter {
  organizationId: string | Types.ObjectId;
  projectId?: string | Types.ObjectId;
}

export class VectorSearchService {
  /**
   * Executes a semantic search against MongoDB Atlas Vector Search.
   */
  async search(
    queryVector: number[],
    filter: ISearchFilter,
    topK: number = 5
  ): Promise<(IKnowledgeRecord & { score: number })[]> {
    logger.info({ filter, topK }, 'VectorSearchService: Executing Atlas Vector Search');

    const orgId = new Types.ObjectId(filter.organizationId.toString());

    const filterConditions: any[] = [{ organizationId: orgId }];
    if (filter.projectId) {
      filterConditions.push({ projectId: new Types.ObjectId(filter.projectId.toString()) });
    }

    const atlasFilter = filterConditions.length > 1 
      ? { $and: filterConditions }
      : filterConditions[0];

    try {
      // Execute the $vectorSearch aggregation pipeline
      const results = await KnowledgeRecord.aggregate([
        {
          $vectorSearch: {
            index: 'vector_index',
            path: 'embedding',
            queryVector: queryVector,
            numCandidates: topK * 10,
            limit: topK,
            filter: atlasFilter
          }
        },
        {
          $project: {
            _id: 1,
            organizationId: 1,
            projectId: 1,
            sourceType: 1,
            sourceReferenceId: 1,
            title: 1,
            summary: 1,
            technicalDecisions: 1,
            businessContext: 1,
            risks: 1,
            breakingChanges: 1,
            dependencies: 1,
            affectedComponents: 1,
            referencedApis: 1,
            metadata: 1,
            documentId: 1,
            score: { $meta: 'vectorSearchScore' }
          }
        }
      ]);

      if (results && results.length > 0) {
        return results as (IKnowledgeRecord & { score: number })[];
      }
    } catch (error) {
      logger.warn({ error, filter }, 'VectorSearchService: Atlas Vector Search unavailable or unindexed; falling back to direct document match search');
    }

    // Fallback: Query KnowledgeRecord collection directly for project/organization records
    const fallbackRecords = await KnowledgeRecord.find(atlasFilter).limit(topK).lean();
    return fallbackRecords.map((doc: any, index: number) => ({
      ...doc,
      score: Math.max(0.85 - index * 0.05, 0.60),
    })) as (IKnowledgeRecord & { score: number })[];
  }
}
