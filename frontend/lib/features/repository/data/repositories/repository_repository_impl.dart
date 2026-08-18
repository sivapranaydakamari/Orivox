import '../../domain/entities/repository.dart';
import '../models/repository_dto.dart';
import '../datasources/repository_remote_data_source.dart';

class RepositoryRepositoryImpl {
  final RepositoryRemoteDataSource _remoteDataSource;

  RepositoryRepositoryImpl(this._remoteDataSource);

  Future<List<Repository>> getRepositories() => _remoteDataSource.getRepositories();

  Future<Repository> getRepositoryById(String id) => _remoteDataSource.getRepositoryById(id);

  Future<Repository> createRepository(CreateRepositoryDto dto) => _remoteDataSource.createRepository(dto);

  Future<Repository> updateRepository(String id, UpdateRepositoryDto dto) => _remoteDataSource.updateRepository(id, dto);

  Future<void> deleteRepository(String id) => _remoteDataSource.deleteRepository(id);

  Future<void> syncRepository(String id) => _remoteDataSource.syncRepository(id);

  Future<Map<String, dynamic>> generateWebhookSecret(String id) => _remoteDataSource.generateWebhookSecret(id);
}
