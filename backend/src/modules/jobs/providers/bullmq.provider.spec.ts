import { describe, it, expect, vi, beforeEach } from 'vitest';
import { BullMqProvider } from './bullmq.provider';
import { JobType } from '../types/job.types';

vi.mock('../../../config/logger', () => ({
  logger: { info: vi.fn(), warn: vi.fn(), error: vi.fn() },
}));

describe('BullMqProvider (Mock)', () => {
  let provider: BullMqProvider;

  beforeEach(() => {
    provider = new BullMqProvider();
    vi.clearAllMocks();
  });

  it('should enqueue a job and return mock id', async () => {
    const jobId = await provider.enqueue(JobType.SYNC_REPOSITORY, { repoId: '123' });
    expect(jobId).toMatch(/^mock_job_/);
  });

  it('should fetch empty failed jobs', async () => {
    const failedJobs = await provider.getFailedJobs(JobType.SYNC_REPOSITORY, 10);
    expect(failedJobs.length).toBe(0);
  });

  it('should not retry job', async () => {
    const result = await provider.retryJob('failed-1');
    expect(result).toBe(false);
  });
});
