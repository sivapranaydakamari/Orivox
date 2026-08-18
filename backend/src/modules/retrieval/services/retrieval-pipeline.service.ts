import { QueryEmbeddingService } from './query-embedding.service';
import { VectorSearchService, ISearchFilter } from './vector-search.service';
import { RetrievalRanker } from './retrieval-ranker.service';
import { IRetrievalEvidence } from '../models/retrieval-evidence.model';
import { logger } from '../../../config/logger';

export class RetrievalPipeline {
  constructor(
    private readonly queryEmbeddingService: QueryEmbeddingService,
    private readonly vectorSearchService: VectorSearchService,
    private readonly retrievalRanker: RetrievalRanker
  ) {}

  /**
   * Orchestrates the entire semantic retrieval flow.
   *
   * User Query -> Embed Query -> Atlas Vector Search -> Rank & Filter -> Evidence
   */
  async retrieve(
    query: string,
    filter: ISearchFilter,
    options?: { topK?: number; minSimilarityScore?: number }
  ): Promise<IRetrievalEvidence[]> {
    logger.info({ query, filter }, 'RetrievalPipeline: Initiating semantic retrieval');

    // 1. Embed Query
    const queryVector = await this.queryEmbeddingService.generateQueryVector(query);

    // 2. Search Vectors
    const rawResults = await this.vectorSearchService.search(queryVector, filter, options?.topK);

    // 3. Rank, Deduplicate, and Format
    const evidence = this.retrievalRanker.rankAndFormat(rawResults, options?.minSimilarityScore);

    logger.info({ count: evidence.length }, 'RetrievalPipeline: Completed semantic retrieval');
    return evidence;
  }
}
