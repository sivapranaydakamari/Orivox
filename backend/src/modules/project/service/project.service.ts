import { Types } from 'mongoose';
import { projectRepository } from '../repository/project.repository';
import { CreateProjectDto, UpdateProjectDto } from '../dto/project.dto';
import { IProject } from '../model/project.model';
import { organizationService } from '../../organization/service/organization.service';

export class ProjectService {
  async createProject(dto: CreateProjectDto): Promise<IProject> {
    const orgExists = await organizationService.getOrganizationById(dto.organizationId);
    if (!orgExists) {
      throw new Error(`Organization with ID ${dto.organizationId} does not exist`);
    }

    const existingProject = await projectRepository.findOne({ 
      organizationId: dto.organizationId, 
      name: dto.name 
    });
    
    if (existingProject) {
      throw new Error(`Project with name '${dto.name}' already exists in this organization`);
    }

    // Attach the organizationId from the auth context
    const projectData = {
      ...dto,
      organizationId: new Types.ObjectId(dto.organizationId),
    } as unknown as Partial<IProject>;

    return projectRepository.create(projectData);
  }

  async getProjects(organizationId: string): Promise<IProject[]> {
    return projectRepository.findMany({ organizationId });
  }

  async getProjectById(id: string): Promise<IProject | null> {
    return projectRepository.findById(id);
  }

  async updateProject(id: string, dto: UpdateProjectDto): Promise<IProject | null> {
    return projectRepository.update(id, dto);
  }

  async deleteProject(id: string): Promise<boolean> {
    const deleted = await projectRepository.delete(id);
    return deleted !== null;
  }
}

export const projectService = new ProjectService();
