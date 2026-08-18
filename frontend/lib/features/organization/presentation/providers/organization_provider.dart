import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/organization_repository.dart';
import '../../data/repositories/organization_repository_impl.dart';
import '../../data/datasources/organization_remote_data_source.dart';
import '../../../../core/network/dio_client.dart';

final organizationRemoteDataSourceProvider = Provider<OrganizationRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return OrganizationRemoteDataSource(dio);
});

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  final remoteDataSource = ref.watch(organizationRemoteDataSourceProvider);
  return OrganizationRepositoryImpl(remoteDataSource);
});

final organizationListProvider = AsyncNotifierProvider<OrganizationListNotifier, List<Organization>>(() {
  return OrganizationListNotifier();
});

class OrganizationListNotifier extends AsyncNotifier<List<Organization>> {
  @override
  Future<List<Organization>> build() async {
    return await ref.watch(organizationRepositoryProvider).getAllOrganizations();
  }

  Future<Organization?> createOrganization(String name, String slug) async {
    state = const AsyncValue.loading();
    try {
      final org = await ref.read(organizationRepositoryProvider).createOrganization(name, slug);
      ref.invalidateSelf();
      return org;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateOrganization(String id, String name) async {
    // Optimistic or just invalidate
    state = const AsyncValue.loading();
    try {
      await ref.read(organizationRepositoryProvider).updateOrganization(id, name);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteOrganization(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(organizationRepositoryProvider).deleteOrganization(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
