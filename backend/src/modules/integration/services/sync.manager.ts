import { Types } from 'mongoose';
import { repositoryRepository } from '../../repository/repository/repository.repository';
import { SyncStatus } from '../../repository/model/repository.model';
import { syncRunRepository } from '../repository/sync-run.repository';
import { SyncRunStatus } from '../models/sync-run.model';
import { sourceRegistry } from '../registry/source.registry';
import { ingestionService } from './ingestion.service';
import { DocumentSourceType } from '../../document/model/document.model';
import { logger } from '../../../config/logger';
import { GitHubInstallation } from '../model/github-installation.model';
import { githubClient } from '../clients/github.client';

export class SyncManager {
  /**
   * Starts synchronization for a given repository ID.
   */
  async startSync(repositoryId: string | Types.ObjectId, providerToken: string | undefined, jobId: string): Promise<Types.ObjectId[]> {
    logger.info({ repositoryId, jobId }, 'SyncManager: Starting sync process');

    // 30 minutes lock expiration for worker recovery
    const lockExpirationTime = new Date(Date.now() - 30 * 60 * 1000);

    // 1. Distributed Lock via Atomic Update
    const lockedRepository = await repositoryRepository.upsert(
      {
        _id: repositoryId,
        $or: [
          { syncStatus: { $ne: SyncStatus.SYNCING } },
          { syncLockedAt: { $lt: lockExpirationTime } },
        ],
      },
      {
        $set: {
          syncStatus: SyncStatus.SYNCING,
          syncLockedAt: new Date(),
          syncLockedBy: jobId,
          syncError: null,
        }
      }
    );

    if (!lockedRepository) {
      logger.warn({ repositoryId, jobId }, 'SyncManager: Sync already in progress or lock could not be acquired');
      return [];
    }

    let syncRun;
    try {
      // 2. Create SyncRun record transactionally
      syncRun = await syncRunRepository.create({
        organizationId: lockedRepository.organizationId,
        projectId: lockedRepository.projectId,
        repositoryId: lockedRepository._id,
        startedAt: new Date(),
        status: SyncRunStatus.IN_PROGRESS,
      });

      // 3. Resolve Provider
      let sourceType: DocumentSourceType;
      switch (lockedRepository.provider.toUpperCase()) {
        case 'GITHUB':
          sourceType = DocumentSourceType.GITHUB;
          break;
        default:
          throw new Error(`SyncManager: Unsupported provider type ${lockedRepository.provider}`);
      }

      const provider = sourceRegistry.getProvider(sourceType);

      // Parse owner and repo name from github URL: https://github.com/owner/repo
      const cleanUrl = lockedRepository.repositoryUrl.replace(/\/$/, '').replace(/^https?:\/\/(www\.)?github\.com\//, '');
      const urlParts = cleanUrl.split('/');
      const owner = urlParts[0];
      const repo = urlParts[1];

      if (!owner || !repo) {
        throw new Error(`SyncManager: Invalid GitHub repository URL format '${lockedRepository.repositoryUrl}'`);
      }

      // Generate App Installation Token if applicable
      let activeToken = providerToken;
      if (lockedRepository.githubInstallationId && !activeToken) {
        const installation = await GitHubInstallation.findById(lockedRepository.githubInstallationId);
        if (installation && installation.installationId) {
          activeToken = await githubClient.getInstallationToken(installation.installationId);
        } else {
          logger.warn({ repositoryId }, 'SyncManager: GitHub installation not found for repository');
        }
      }

      // 4. Build Sync State
      const currentSyncState = {
        token: activeToken || '',
        owner,
        repo,
        organizationId: lockedRepository.organizationId.toString(),
        projectId: lockedRepository.projectId.toString(),
        repositoryId: lockedRepository._id.toString(),
        lastSuccessfulSync: lockedRepository.lastSuccessfulSync,
        lastProcessedPullRequest: lockedRepository.lastProcessedPullRequest || 0,
      };

      // 5. Execute Sync on Provider (Extension Point: Future Retry Logic goes here)
      const { artifacts, nextSyncState } = await provider.sync(currentSyncState);

      logger.info({ artifactCount: artifacts.length }, 'SyncManager: Artifacts retrieved');

      // 6. Bulk Ingest Artifacts into Document collection
      const documentIds = await ingestionService.bulkIngestArtifacts(artifacts);
      
      const documentsImported = artifacts.length;
      const documentsUpdated = 0;
      const failedDocuments = 0;

      // 7. Mark as Success & Unlock
      await repositoryRepository.update(lockedRepository._id, {
        syncStatus: SyncStatus.SUCCESS,
        syncLockedAt: null,
        syncLockedBy: null,
        lastSuccessfulSync: new Date(),
        lastProcessedPullRequest: nextSyncState.lastProcessedPullRequest as number,
      });

      await syncRunRepository.update(syncRun._id.toString(), {
        finishedAt: new Date(),
        status: SyncRunStatus.SUCCESS,
        documentsImported,
        documentsUpdated,
        failedDocuments,
      });

      logger.info({ repositoryId, jobId }, 'SyncManager: Sync completed successfully');
      return documentIds;
    } catch (error: unknown) {
      logger.error({ error, repositoryId, jobId }, 'SyncManager: Sync failed');
      
      const errorMessage = (error as Error).message || 'Unknown synchronization error';

      // Mark Repository as Failed & Unlock
      await repositoryRepository.update(repositoryId, {
        syncStatus: SyncStatus.FAILED,
        syncLockedAt: null,
        syncLockedBy: null,
        syncError: errorMessage,
      });

      if (syncRun) {
        await syncRunRepository.update(syncRun._id.toString(), {
          finishedAt: new Date(),
          status: SyncRunStatus.FAILED,
        });
      }
      
      throw error;
    }
  }
}

export const syncManager = new SyncManager();
