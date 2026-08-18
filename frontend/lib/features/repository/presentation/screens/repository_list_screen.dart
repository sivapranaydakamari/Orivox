import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../providers/repository_providers.dart';
import '../widgets/repository_card.dart';
import '../../../../core/widgets/saas_layout.dart';

class RepositoryListScreen extends ConsumerWidget {
  final String? projectId;

  const RepositoryListScreen({
    super.key,
    this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);
    final repositoriesAsync = ref.watch(repositoryListProvider(projectId));

    return SaaSLayout(
      title: 'Repositories',
      actions: [
        if (projectId != null && permissions.canCreateRepository(projectId!))
          IconButton(
            onPressed: () => context.push('/projects/$projectId/repositories/new'),
            icon: const Icon(Icons.add),
          ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repositories', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                if (projectId != null && permissions.canCreateRepository(projectId!))
                  ElevatedButton.icon(
                    onPressed: () => context.push('/projects/$projectId/repositories/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Repository'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            repositoriesAsync.when(
              data: (repositories) {
                if (repositories.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.source_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No Repositories Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Connect a repository to sync knowledge.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: repositories.length,
                  itemBuilder: (context, index) {
                    final repository = repositories[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RepositoryCard(
                        repository: repository,
                        onTap: () {
                          context.push('/repositories/${repository.id}');
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(64.0), child: CircularProgressIndicator())),
              error: (error, stack) => ErrorState(
                message: 'Failed to load repositories: $error',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
