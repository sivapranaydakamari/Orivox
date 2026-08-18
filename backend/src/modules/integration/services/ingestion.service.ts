import { Types } from 'mongoose';
import { IRawArtifact } from '../models/raw-artifact.model';
import { IDocument, DocumentStatus } from '../../document/model/document.model';
import { documentRepository } from '../../document/repository/document.repository';
import { logger } from '../../../config/logger';
import { ClientSession } from 'mongoose';

export class IngestionService {
  /**
   * Normalizes a Raw Artifact into a persistent Document entity.
   */
  async ingestArtifact(artifact: IRawArtifact, session?: ClientSession): Promise<IDocument> {
    try {
      logger.info({ sourceType: artifact.sourceType, externalId: artifact.externalId }, 'Ingesting raw artifact');

      // Duplicate Detection and Atomic Upsert
      const filter = {
        projectId: new Types.ObjectId(artifact.projectId),
        sourceType: artifact.sourceType,
        externalId: artifact.externalId,
      };

      const updateData = {
        $set: {
          title: artifact.title,
          rawContent: artifact.content,
          metadata: artifact.metadata,
          status: DocumentStatus.PENDING, // Ready for extraction pipeline or re-extraction
        },
        $setOnInsert: {
          organizationId: new Types.ObjectId(artifact.organizationId),
          uploadedBy: artifact.uploadedBy ? new Types.ObjectId(artifact.uploadedBy) : undefined,
          createdBy: artifact.uploadedBy ? new Types.ObjectId(artifact.uploadedBy) : undefined,
        }
      };

      const upsertedDocument = await documentRepository.upsert(filter, updateData, session);
      
      logger.info({ documentId: upsertedDocument._id }, 'Document successfully upserted from raw artifact');
      
      return upsertedDocument;
    } catch (error) {
      logger.error({ error, artifact }, 'Failed to ingest raw artifact');
      throw error;
    }
  }

  /**
   * Bulk ingests multiple Raw Artifacts into persistent Document entities.
   */
  async bulkIngestArtifacts(artifacts: IRawArtifact[]): Promise<Types.ObjectId[]> {
    if (!artifacts || artifacts.length === 0) return [];

    try {
      logger.info({ artifactCount: artifacts.length }, 'Bulk ingesting raw artifacts');

      const operations = artifacts.map((artifact) => ({
        updateOne: {
          filter: {
            projectId: new Types.ObjectId(artifact.projectId),
            sourceType: artifact.sourceType,
            externalId: artifact.externalId,
          },
          update: {
            $set: {
              title: artifact.title,
              rawContent: artifact.content,
              metadata: artifact.metadata,
              status: DocumentStatus.PENDING,
            },
            $setOnInsert: {
              organizationId: new Types.ObjectId(artifact.organizationId),
              uploadedBy: artifact.uploadedBy ? new Types.ObjectId(artifact.uploadedBy) : undefined,
              createdBy: artifact.uploadedBy ? new Types.ObjectId(artifact.uploadedBy) : undefined,
            },
          },
          upsert: true,
        },
      }));

      await documentRepository.bulkWrite(operations);
      logger.info({ artifactCount: artifacts.length }, 'Documents successfully bulk upserted');

      const projectIds = [...new Set(artifacts.map(a => a.projectId))];
      const externalIds = artifacts.map(a => a.externalId);
      
      const ingestedDocs = await documentRepository.findMany({
        projectId: { $in: projectIds.map(id => new Types.ObjectId(id)) },
        externalId: { $in: externalIds }
      });
      
      return ingestedDocs.map(d => d._id as Types.ObjectId);
    } catch (error) {
      logger.error({ error, artifactCount: artifacts?.length }, 'Failed to bulk ingest raw artifacts');
      throw error;
    }
  }

  /**
   * Deletes artifacts and cascades deletion to KnowledgeRecords (which holds the vectors).
   */
  async deleteArtifacts(externalIds: string[], projectId: string): Promise<void> {
    if (!externalIds || externalIds.length === 0) return;

    try {
      logger.info({ artifactCount: externalIds.length, projectId }, 'Deleting artifacts');

      // 1. Find the documents to be deleted to get their IDs
      const docsToDelete = await documentRepository.findMany({
        projectId: new Types.ObjectId(projectId),
        externalId: { $in: externalIds },
      });

      if (docsToDelete.length === 0) {
        logger.info('No documents found to delete');
        return;
      }

      const docIds = docsToDelete.map((d) => d._id);

      // 2. Cascade delete: Delete KnowledgeRecords (which also deletes the Vector since it is embedded)
      const { KnowledgeRecord } = await import('../../knowledge/model/knowledgeRecord.model');
      await KnowledgeRecord.deleteMany({ documentId: { $in: docIds } });

      // 3. Delete the actual Documents
      await documentRepository.deleteMany({ _id: { $in: docIds } });

      logger.info({ deletedCount: docIds.length }, 'Successfully deleted documents and cascaded to KnowledgeRecords');
    } catch (error) {
      logger.error({ error, externalIds }, 'Failed to delete artifacts');
      throw error;
    }
  }
}

export const ingestionService = new IngestionService();
