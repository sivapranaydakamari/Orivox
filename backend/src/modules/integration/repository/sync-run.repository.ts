import { BaseRepository } from '../../../shared/repository/base.repository';
import { ISyncRun, SyncRunModel } from '../models/sync-run.model';

export class SyncRunRepository extends BaseRepository<ISyncRun> {
  constructor() {
    super(SyncRunModel);
  }
}

export const syncRunRepository = new SyncRunRepository();
