import { BaseRepository } from '../../../shared/repository/base.repository';
import { IProject, Project } from '../model/project.model';

export class ProjectRepository extends BaseRepository<IProject> {
  constructor() {
    super(Project);
  }
}

export const projectRepository = new ProjectRepository();
