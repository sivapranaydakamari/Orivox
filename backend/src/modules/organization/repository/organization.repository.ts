import { BaseRepository } from '../../../shared/repository/base.repository';
import { IOrganization, Organization } from '../model/organization.model';

export class OrganizationRepository extends BaseRepository<IOrganization> {
  constructor() {
    super(Organization);
  }
}

export const organizationRepository = new OrganizationRepository();
