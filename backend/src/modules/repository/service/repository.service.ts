import { Types } from 'mongoose';
import { repositoryRepository } from '../repository/repository.repository';
import { CreateRepositoryDto, UpdateRepositoryDto } from '../dto/repository.dto';
import { IRepository } from '../model/repository.model';
import { projectService } from '../../project/service/project.service';
import { outboxEventRepository } from '../../jobs/repository/outbox-event.repository';
import { JobType } from '../../jobs/types/job.types';

export class RepositoryService {
  async createRepository(dto: CreateRepositoryDto): Promise<IRepository> {
    const project = await projectService.getProjectById(dto.projectId);
    if (!project) {
      throw new Error(`Project with ID ${dto.projectId} does not exist`);
    }

    const existingRepo = await repositoryRepository.findOne({ 
      projectId: dto.projectId, 
      repositoryUrl: dto.repositoryUrl 
    });
    
    if (existingRepo) {
      throw new Error(`Repository with URL '${dto.repositoryUrl}' already exists in this project`);
    }

    // Attach the organizationId from the project
    const repoData = {
      ...dto,
      organizationId: new Types.ObjectId(project.organizationId.toString()),
      projectId: new Types.ObjectId(dto.projectId),
      provider: dto.provider || 'GITHUB',
    } as unknown as Partial<IRepository>;

    const repository = await repositoryRepository.create(repoData);

    // Trigger repository sync
    await outboxEventRepository.create({
      jobType: JobType.SYNC_REPOSITORY,
      payload: { repositoryId: repository._id.toString() },
      status: 'PENDING'
    } as any);

    return repository;
  }

  async getRepositories(organizationId: string): Promise<IRepository[]> {
    return repositoryRepository.findMany({ organizationId });
  }

  async getRepositoryById(id: string): Promise<IRepository | null> {
    return repositoryRepository.findById(id);
  }

  async updateRepository(id: string, dto: UpdateRepositoryDto): Promise<IRepository | null> {
    return repositoryRepository.update(id, dto);
  }

  async deleteRepository(id: string): Promise<boolean> {
    const deleted = await repositoryRepository.delete(id);
    return deleted !== null;
  }
}

export const repositoryService = new RepositoryService();
