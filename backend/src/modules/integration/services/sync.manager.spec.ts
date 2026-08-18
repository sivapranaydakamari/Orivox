import { describe, it, expect, vi, beforeEach } from 'vitest';
import { SyncManager } from './sync.manager';
import { repositoryRepository } from '../../repository/repository/repository.repository';
import { syncRunRepository } from '../repository/sync-run.repository';
import { ingestionService } from './ingestion.service';
import mongoose from 'mongoose';

vi.mock('../../repository/repository/repository.repository');
vi.mock('../repository/sync-run.repository');
vi.mock('./ingestion.service');
vi.mock('../../../config/logger', () => ({
  logger: { info: vi.fn(), warn: vi.fn(), error: vi.fn() },
}));

describe('SyncManager', () => {
  let syncManager: SyncManager;

  beforeEach(() => {
    syncManager = new SyncManager();
    vi.clearAllMocks();

    vi.spyOn(mongoose, 'startSession').mockResolvedValue({
      startTransaction: vi.fn(),
      commitTransaction: vi.fn(),
      abortTransaction: vi.fn(),
      endSession: vi.fn(),
    } as any);
  });

  it('should acquire distributed lock via atomic upsert', async () => {
    const mockRepo = { _id: 'repo123', organizationId: 'org1', projectId: 'proj1', provider: 'GITHUB', repositoryUrl: 'https://github.com/foo/bar' };
    
    // Mock successful lock acquisition
    (repositoryRepository.upsert as any).mockResolvedValue(mockRepo);
    (syncRunRepository.create as any).mockResolvedValue({ _id: 'run123' });
    
    // Ingestion flow mock
    (ingestionService.ingestArtifact as any).mockResolvedValue(undefined);
    
    // Mock sourceRegistry and github client indirectly by making it throw early or mocking it
    // For simplicity, we just test the lock acquisition logic before the provider call
    try {
      await syncManager.startSync('repo123', 'token', 'job-123');
    } catch (e) {
      // It might throw because we didn't mock the Github client completely, but we can verify upsert was called
    }

    expect(repositoryRepository.upsert).toHaveBeenCalledWith(
      expect.objectContaining({ _id: 'repo123' }),
      expect.objectContaining({
        $set: expect.objectContaining({ syncStatus: 'SYNCING', syncLockedBy: 'job-123' })
      })
    );
  });

  it('should return empty array if lock cannot be acquired', async () => {
    (repositoryRepository.upsert as any).mockResolvedValue(null);

    const result = await syncManager.startSync('repo123', 'token', 'job-123');
    expect(result).toEqual([]);
    expect(mongoose.startSession).not.toHaveBeenCalled();
  });
});
