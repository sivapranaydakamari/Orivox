import { IDocument, DocumentSourceType, DocumentStatus } from '../../document/model/document.model';
import { documentService } from '../../document/service/document.service';
import { Types } from 'mongoose';
import { queueService } from '../../jobs/queue.service';
import { JobType } from '../../jobs/types/job.types';
import { logger } from '../../../config/logger';

export class PostmanIngestionService {
  /**
   * Accepts a raw Postman Collection JSON, parses it to extract endpoints,
   * redacts secrets from headers/body, and stores it as a Document for extraction.
   */
  async ingestCollection(
    projectId: string,
    organizationId: string,
    collectionJson: string,
    userId: string
  ): Promise<IDocument> {
    
    let parsedCollection;
    try {
      parsedCollection = JSON.parse(collectionJson);
    } catch (error) {
      throw new Error('Invalid Postman Collection JSON');
    }

    if (!parsedCollection.info || !parsedCollection.info.name) {
      throw new Error('Invalid Postman Collection format. Missing info.name.');
    }

    // Process and redact the collection
    const processedContent = this.processCollection(parsedCollection);

    // Create the document
    const document = await documentService.createDocument({
      organizationId: new Types.ObjectId(organizationId) as any,
      projectId: new Types.ObjectId(projectId) as any,
      sourceType: DocumentSourceType.POSTMAN,
      externalId: `postman_${Date.now()}`,
      title: parsedCollection.info.name,
      rawContent: JSON.stringify(processedContent),
      status: DocumentStatus.PENDING,
    });

    // Enqueue job for extraction (which splits it into knowledge records and embeds it)
    await queueService.enqueue(JobType.EXTRACT_DOCUMENT, {
      documentId: document._id.toString(),
      projectId,
      organizationId,
    });

    logger.info({ documentId: document._id }, 'Postman collection ingested and queued for extraction');

    return document;
  }

  private processCollection(collection: any): any {
    const endpoints: any[] = [];
    this.extractItems(collection.item, endpoints, '');
    return { name: collection.info.name, endpoints };
  }

  private extractItems(items: any[], endpoints: any[], currentPath: string) {
    if (!items || !Array.isArray(items)) return;

    for (const item of items) {
      if (item.item) {
        // It's a folder
        this.extractItems(item.item, endpoints, `${currentPath}/${item.name}`);
      } else if (item.request) {
        // It's a request
        const request = item.request;
        const url = typeof request.url === 'string' ? request.url : request.url?.raw || '';
        
        // Ensure a stable request identifier for idempotency
        const requestId = item.id || `${item.name}-${request.method}-${url}`;

        endpoints.push({
          id: requestId,
          folderPath: currentPath,
          name: item.name,
          method: request.method,
          url: url,
          description: request.description || '',
          headers: this.redactHeaders(request.header),
          body: this.redactBody(request.body),
        });
      }
    }
  }

  private redactHeaders(headers: any[]): any[] {
    if (!headers || !Array.isArray(headers)) return [];
    
    return headers.map(h => {
      const key = (h.key || '').toLowerCase();
      if (key === 'authorization' || key.includes('api-key') || key.includes('token') || key.includes('secret')) {
        return { ...h, value: '[REDACTED_SECRET]' };
      }
      return h;
    });
  }

  private redactBody(body: any): string {
    if (!body || !body.raw) return '';
    try {
      let rawString = body.raw;
      const secretRegex = /(eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+)|((?:sk|pk)_[a-zA-Z0-9]{20,})|(Bearer\s+[a-zA-Z0-9\-\._~+\/]+=*)/g;
      rawString = rawString.replace(secretRegex, '[REDACTED_SECRET]');
      
      const parsedBody = JSON.parse(rawString);
      // Recursively redact keys
      const redactKeys = (obj: any) => {
        if (!obj || typeof obj !== 'object') return;
        for (const key in obj) {
          const lKey = key.toLowerCase();
          if (lKey.includes('password') || lKey.includes('secret') || lKey.includes('token')) {
            obj[key] = '[REDACTED_SECRET]';
          } else if (typeof obj[key] === 'object') {
            redactKeys(obj[key]);
          }
        }
      };
      redactKeys(parsedBody);
      return JSON.stringify(parsedBody, null, 2);
    } catch {
      // If it's not JSON, just regex string replacement
      let rawString = body.raw || '';
      const secretRegex = /(eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+)|((?:sk|pk)_[a-zA-Z0-9]{20,})|(Bearer\s+[a-zA-Z0-9\-\._~+\/]+=*)/g;
      return rawString.replace(secretRegex, '[REDACTED_SECRET]');
    }
  }
}

export const postmanIngestionService = new PostmanIngestionService();
