import { BaseRepository } from '../../../shared/repository/base.repository';
import { IAuditLog, AuditLog } from '../model/auditLog.model';

export class AuditLogRepository extends BaseRepository<IAuditLog> {
  constructor() {
    super(AuditLog);
  }
}

export const auditLogRepository = new AuditLogRepository();
