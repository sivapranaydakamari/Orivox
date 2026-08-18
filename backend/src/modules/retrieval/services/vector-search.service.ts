import { Types } from 'mongoose';
import { KnowledgeRecord, IKnowledgeRecord } from '../../knowledge/model/knowledgeRecord.model';
import { logger } from '../../../config/logger';

export interface ISearchFilter {
  organizationId: string | Types.ObjectId;
  projectId: string | Types.ObjectId;
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
    const projId = new Types.ObjectId(filter.projectId.toString());

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
            filter: {
              $and: [
                { organizationId: orgId },
                { projectId: projId }
              ]
            }
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

      return results as (IKnowledgeRecord & { score: number })[];
    } catch (error) {
      logger.error({ error, filter }, 'VectorSearchService: Atlas Vector Search failed');
      throw new Error(`Vector Search execution failed: ${(error as Error).message}`);
    }
  }
}
