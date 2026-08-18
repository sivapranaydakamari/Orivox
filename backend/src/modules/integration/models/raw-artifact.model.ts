import { Types } from 'mongoose';
import { DocumentSourceType } from '../../document/model/document.model';

export interface IRawArtifact {
  sourceType: DocumentSourceType;
  externalId: string;
  title: string;
  content: string;
  metadata: Record<string, unknown>;
  importedAt: Date;
  
  // Normalized organizational mapping
  organizationId: Types.ObjectId | string;
  projectId: Types.ObjectId | string;
  
  // Optional depending on source
  repositoryId?: Types.ObjectId | string;
  uploadedBy?: Types.ObjectId | string;
}
