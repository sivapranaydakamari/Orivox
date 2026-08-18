import '../../domain/repositories/organization_repository.dart';
import '../../domain/entities/organization.dart';
import '../datasources/organization_remote_data_source.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDataSource _remoteDataSource;

  OrganizationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Organization>> getAllOrganizations() async {
    final models = await _remoteDataSource.getAllOrganizations();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Organization> getOrganizationById(String id) async {
    final model = await _remoteDataSource.getOrganizationById(id);
    return model.toEntity();
  }

  @override
  Future<Organization> createOrganization(String name, String slug) async {
    final model = await _remoteDataSource.createOrganization(name, slug);
    return model.toEntity();
  }

  @override
  Future<Organization> updateOrganization(String id, String name) async {
    final model = await _remoteDataSource.updateOrganization(id, name);
    return model.toEntity();
  }

  @override
  Future<void> deleteOrganization(String id) async {
    await _remoteDataSource.deleteOrganization(id);
  }
}
