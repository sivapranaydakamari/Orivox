import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../providers/repository_providers.dart';
import '../widgets/sync_status_badge.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/repository_dto.dart';

class RepositoryDetailsScreen extends ConsumerWidget {
  final String repositoryId;

  const RepositoryDetailsScreen({
    super.key,
    required this.repositoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);
    final repositoryAsync = ref.watch(repositoryDetailsProvider(repositoryId));
    final actionState = ref.watch(repositoryActionProvider);
    final theme = Theme.of(context);

    // Listen for action state changes to show snackbar
    ref.listen<AsyncValue<void>>(
      repositoryActionProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Action failed: $error')),
            );
          },
          data: (_) {
            if (previous?.isLoading == true && !next.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Action completed successfully')),
              );
            }
          },
        );
      },
    );

    return SaaSLayout(
      title: 'Repository Details',
      actions: [
        repositoryAsync.maybeWhen(
          data: (repository) => permissions.canDeleteRepository(repository.projectId)
              ? IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: theme.colorScheme.error,
                  onPressed: () => _showDeleteDialog(context, ref),
                )
              : const SizedBox.shrink(),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, repositoryAsync, permissions, actionState),
        desktop: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: Responsive.tabletMaxSize),
            width: double.infinity,
            height: double.infinity,
            child: _buildContent(context, ref, repositoryAsync, permissions, actionState),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue repositoryAsync,
    Permissions permissions,
    AsyncValue<void> actionState,
  ) {
    return repositoryAsync.when(
      data: (repository) {
        final formattedTime = repository.lastSuccessfulSync != null
            ? DateFormat.yMMMd().add_jm().format(repository.lastSuccessfulSync!)
            : 'Never synchronized';

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(repositoryDetailsProvider(repositoryId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Overview'),
                InfoCard(
                  title: repository.repositoryName,
                  description: repository.repositoryUrl,
                  icon: Icons.source,
                ),
                const SizedBox(height: AppSpacing.lg),
                
                const SectionHeader(title: 'Sync Status'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current State',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SyncStatusBadge(
                              status: repository.syncStatus,
                              isActive: repository.isActive,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Last Synchronized',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              formattedTime,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (repository.syncError != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              repository.syncError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                if (permissions.canSyncRepository(repository.projectId) || permissions.canEditRepository(repository.projectId))
                  const SectionHeader(title: 'Actions'),

                if (permissions.canSyncRepository(repository.projectId))
                  PrimaryButton(
                    text: 'View Sync Dashboard',
                    icon: Icons.dashboard,
                    onPressed: () => context.push('/repositories/$repositoryId/sync-dashboard'),
                  ),

                if (permissions.canEditRepository(repository.projectId)) ...[
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    text: repository.isActive ? 'Disable Repository' : 'Enable Repository',
                    isLoading: actionState.isLoading,
                    onPressed: () {
                      ref.read(repositoryActionProvider.notifier).updateRepository(
                            repository.id,
                            UpdateRepositoryDto(isActive: !repository.isActive),
                          );
                    },
                  ),
                ]
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingWidget(message: 'Loading repository details...'),
      error: (error, stack) => ErrorState(
        message: 'Failed to load repository: $error',
        onRetry: () => ref.invalidate(repositoryDetailsProvider(repositoryId)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Repository',
        message: 'Are you sure you want to delete this repository? This action cannot be undone.',
        confirmText: 'Delete',
        onConfirm: () {
          Navigator.of(context).pop();
          ref.read(repositoryActionProvider.notifier).deleteRepository(repositoryId).then((_) {
            if (context.mounted) {
              context.pop(); // Go back to list after delete
            }
          });
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
