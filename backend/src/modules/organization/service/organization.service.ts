import { organizationRepository } from '../repository/organization.repository';
import { CreateOrganizationDto, UpdateOrganizationDto } from '../dto/organization.dto';
import { IOrganization } from '../model/organization.model';

import mongoose from 'mongoose';
import { userRepository } from '../../user/repository/user.repository';
import { OrgRole } from '../../user/model/user.model';

export class OrganizationService {
  async createOrganization(userId: string, dto: CreateOrganizationDto): Promise<IOrganization> {
    const existing = await organizationRepository.findOne({ slug: dto.slug });
    if (existing) {
      throw new Error(`Organization with slug '${dto.slug}' already exists`);
    }

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const organization = await organizationRepository.create(dto, session);

      const user = await userRepository.findById(userId);
      if (!user) {
        throw new Error('User not found');
      }

      // Check if they already belong to this org (unlikely since it was just created)
      const hasMembership = user.memberships.some(m => m.organizationId.toString() === organization._id.toString());
      if (!hasMembership) {
        user.memberships.push({
          organizationId: organization._id as mongoose.Types.ObjectId,
          orgRole: OrgRole.ORG_ADMIN,
          projectRoles: []
        });
        await user.save({ session });
      }

      await session.commitTransaction();
      return organization;
    } catch (error) {
      await session.abortTransaction();
      throw error;
    } finally {
      session.endSession();
    }
  }

  async getOrganizations(ids: string[]): Promise<IOrganization[]> {
    if (ids.length === 0) return [];
    return organizationRepository.findMany({ _id: { $in: ids } });
  }

  async getOrganizationById(id: string): Promise<IOrganization | null> {
    return organizationRepository.findById(id);
  }

  async updateOrganization(id: string, dto: UpdateOrganizationDto): Promise<IOrganization | null> {
    return organizationRepository.update(id, dto);
  }

  async deleteOrganization(id: string): Promise<boolean> {
    const deleted = await organizationRepository.delete(id);
    return deleted !== null;
  }
}

export const organizationService = new OrganizationService();
