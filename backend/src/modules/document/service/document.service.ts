import { documentRepository } from '../repository/document.repository';
import { GetDocumentsQueryDto } from '../dto/document.dto';
import { IDocument } from '../model/document.model';

export class DocumentService {
  async getDocuments(query: GetDocumentsQueryDto, organizationId: string): Promise<IDocument[]> {
    const filter: Record<string, unknown> = { organizationId };
    if (query.projectId) {
      filter.projectId = query.projectId;
    }
    if (query.status) {
      filter.status = query.status;
    }
    if (query.repositoryId) {
      filter['metadata.repositoryId'] = query.repositoryId;
    }
    return documentRepository.findMany(filter);
  }

  async getDocumentById(id: string): Promise<IDocument | null> {
    return documentRepository.findById(id);
  }

  async createDocument(data: Partial<IDocument>): Promise<IDocument> {
    const document = await documentRepository.create(data);
    return document;
  }
}

export const documentService = new DocumentService();
