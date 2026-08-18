import { describe, it, expect, vi, beforeEach } from 'vitest';
import { IngestionService } from './ingestion.service';
import { documentRepository } from '../../document/repository/document.repository';
import { Types } from 'mongoose';
import { DocumentStatus } from '../../document/model/document.model';

vi.mock('../../document/repository/document.repository');
vi.mock('../../../config/logger', () => ({
  logger: { info: vi.fn(), warn: vi.fn(), error: vi.fn() },
}));

describe('IngestionService', () => {
  let ingestionService: IngestionService;

  beforeEach(() => {
    ingestionService = new IngestionService();
    vi.resetAllMocks();
  });

  it('should atomically upsert document to ensure idempotency', async () => {
    const artifact = {
      projectId: new Types.ObjectId().toString(),
      organizationId: new Types.ObjectId().toString(),
      sourceType: 'GITHUB',
      externalId: 'issue-123',
      title: 'Fix bug',
      content: 'Bug details here',
      metadata: { author: 'user' },
    } as any;

    const mockUpsertedDoc = { _id: new Types.ObjectId(), ...artifact };
    (documentRepository.upsert as any).mockResolvedValue(mockUpsertedDoc);

    const result = await ingestionService.ingestArtifact(artifact);

    expect(documentRepository.upsert).toHaveBeenCalledWith(
      expect.objectContaining({
        projectId: expect.any(Types.ObjectId),
        sourceType: 'GITHUB',
        externalId: 'issue-123',
      }),
      expect.objectContaining({
        $set: {
          title: 'Fix bug',
          rawContent: 'Bug details here',
          metadata: { author: 'user' },
          status: DocumentStatus.PENDING,
        }
      }),
      undefined // session
    );
    expect(result).toEqual(mockUpsertedDoc);
  });
});
