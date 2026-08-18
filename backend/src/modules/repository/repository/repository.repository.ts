import { BaseRepository } from '../../../shared/repository/base.repository';
import { IRepository, Repository } from '../model/repository.model';

export class RepositoryRepository extends BaseRepository<IRepository> {
  constructor() {
    super(Repository);
  }
}

export const repositoryRepository = new RepositoryRepository();
