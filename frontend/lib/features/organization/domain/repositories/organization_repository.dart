import '../entities/organization.dart';

abstract class OrganizationRepository {
  Future<List<Organization>> getAllOrganizations();
  Future<Organization> getOrganizationById(String id);
  Future<Organization> createOrganization(String name, String slug);
  Future<Organization> updateOrganization(String id, String name);
  Future<void> deleteOrganization(String id);
}
