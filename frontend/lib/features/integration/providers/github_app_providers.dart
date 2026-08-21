import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/github_app_api.dart';

final githubInstallationsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(githubAppApiProvider);
  return await api.getInstallations();
});

final githubRepositoriesProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, String>((ref, installationId) async {
  final api = ref.watch(githubAppApiProvider);
  return await api.getRepositories(installationId);
});

final githubAllRepositoriesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(githubAppApiProvider);
  return await api.getAllRepositories();
});
