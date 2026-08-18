import { Types } from 'mongoose';
import { auditLogRepository } from '../repository/auditLog.repository';
import { IAuditLog } from '../model/auditLog.model';

export class AuditService {
  /**
   * Logs an action for auditing purposes.
   */
  async logAction(
    organizationId: string,
    action: string,
    resourceType: string,
    resourceId?: string,
    userId?: string,
    projectId?: string,
    metadata?: Record<string, unknown>
  ): Promise<IAuditLog> {
    const logData = {
      organizationId: new Types.ObjectId(organizationId),
      action,
      resourceType,
      resourceId,
      userId: userId ? new Types.ObjectId(userId) : undefined,
      projectId: projectId ? new Types.ObjectId(projectId) : undefined,
      metadata,
    };
    
    // Fire and forget is acceptable for audit logging in this scenario to not block requests
    return auditLogRepository.create(logData);
  }
}

export const auditService = new AuditService();
