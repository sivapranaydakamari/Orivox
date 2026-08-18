import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/widgets/layout.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../providers/job_providers.dart';
import '../providers/repository_providers.dart';
import '../widgets/status_timeline.dart';
import '../widgets/job_details_card.dart';
import '../widgets/sync_status_badge.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/sync_status.dart';

class SyncDashboardScreen extends ConsumerWidget {
  final String repositoryId;

  const SyncDashboardScreen({
    super.key,
    required this.repositoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);
    final repositoryAsync = ref.watch(repositoryDetailsProvider(repositoryId));
    final pollingStateAsync = ref.watch(syncPollingProvider(repositoryId));
    final actionState = ref.watch(repositoryActionProvider);

    ref.listen<AsyncValue<void>>(
      repositoryActionProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            final cleanMessage = ApiErrorHandler.getMessage(error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cleanMessage),
                action: SnackBarAction(
                  label: 'Details',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Technical Error Details'),
                        content: SingleChildScrollView(
                          child: SelectableText(error.toString()),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
      title: 'Sync Dashboard',
      actions: [
        repositoryAsync.maybeWhen(
          data: (repository) {
            if (permissions.canDeleteRepository(repository.projectId)) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Theme.of(context).colorScheme.error,
                tooltip: 'Disconnect Repository',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      title: 'Disconnect Repository',
                      message: 'Are you sure you want to disconnect and delete ${repository.repositoryName}? This will remove all associated knowledge and stop the webhook synchronization.',
                      confirmText: 'Disconnect',
                      onConfirm: () async {
                        Navigator.pop(context);
                        await ref.read(repositoryActionProvider.notifier).deleteRepository(repositoryId);
                        if (context.mounted) {
                          context.go('/projects/${repository.projectId}');
                        }
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
      child: ResponsiveLayout(
        mobile: _buildContent(context, ref, repositoryAsync, pollingStateAsync, permissions, actionState),
        desktop: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: Responsive.tabletMaxSize),
            width: double.infinity,
            height: double.infinity,
            child: _buildContent(context, ref, repositoryAsync, pollingStateAsync, permissions, actionState),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue repositoryAsync,
    AsyncValue<SyncPollingState> pollingStateAsync,
    Permissions permissions,
    AsyncValue<void> actionState,
  ) {
    return repositoryAsync.when(
      data: (repository) {
        // If polling state has data, use its syncStatus, otherwise fallback to repository
        final String currentSyncStatusStr = pollingStateAsync.valueOrNull?.statusData['syncStatus'] ?? 
                                            repository.syncStatus.name.toUpperCase();
        
        final currentSyncStatus = _parseSyncStatus(currentSyncStatusStr);

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(repositoryDetailsProvider(repositoryId));
            ref.invalidate(syncPollingProvider(repositoryId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Repository Status'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(repository.repositoryName, style: Theme.of(context).textTheme.titleMedium),
                        SyncStatusBadge(status: currentSyncStatus, isActive: repository.isActive),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                const SectionHeader(title: 'Configuration'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sync Mode:'),
                            Text(repository.syncMode, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Webhook Status:'),
                            Text(repository.webhookStatus, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (permissions.canEditRepository(repository.projectId)) ...[
                          const SizedBox(height: AppSpacing.md),
                          SecondaryButton(
                            text: repository.webhookStatus == 'NOT_CONFIGURED' ? 'Generate Webhook Secret' : 'Regenerate Webhook Secret',
                            icon: Icons.key,
                            isLoading: actionState.isLoading,
                            onPressed: () async {
                              final data = await ref.read(repositoryActionProvider.notifier).generateWebhookSecret(repositoryId);
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    bool isObscured = true;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text('Webhook Configuration'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Configure this in GitHub. This secret will only be shown ONCE.'),
                                              const SizedBox(height: AppSpacing.md),
                                              const Text('Payload URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: SelectableText(data['webhookUrl'] as String),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.copy, size: 20),
                                                    tooltip: 'Copy URL',
                                                    onPressed: () {
                                                      Clipboard.setData(ClipboardData(text: data['webhookUrl'] as String));
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Webhook URL copied to clipboard!')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: AppSpacing.sm),
                                              const Text('Secret:', style: TextStyle(fontWeight: FontWeight.bold)),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      isObscured ? '••••••••••••••••••••••••••••••••' : (data['secret'] as String),
                                                      style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off, size: 20),
                                                    onPressed: () {
                                                      setState(() {
                                                        isObscured = !isObscured;
                                                      });
                                                    },
                                                    tooltip: isObscured ? 'Reveal Secret' : 'Hide Secret',
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.copy, size: 20),
                                                    tooltip: 'Copy Secret',
                                                    onPressed: () {
                                                      Clipboard.setData(ClipboardData(text: data['secret'] as String));
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Webhook Secret copied to clipboard!')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('I have copied it'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                const SectionHeader(title: 'Metrics'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Files Added:'),
                          Text('${repository.filesAdded}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Files Modified:'),
                          Text('${repository.filesModified}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Files Deleted:'),
                          Text('${repository.filesDeleted}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('PRs Processed:'),
                          Text('${repository.prsProcessed}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                const SectionHeader(title: 'Pipeline Status'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: StatusTimeline(
                      stages: _buildPipelineStages(currentSyncStatus),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (pollingStateAsync.valueOrNull?.currentJob != null) ...[
                  const SectionHeader(title: 'Current Running Job'),
                  JobDetailsCard(job: pollingStateAsync.value!.currentJob!),
                  const SizedBox(height: AppSpacing.lg),
                ],

                if (permissions.canSyncRepository(repository.projectId) && currentSyncStatus == SyncStatus.failed) ...[
                  PrimaryButton(
                    text: 'Retry Sync',
                    icon: Icons.refresh,
                    isLoading: actionState.isLoading,
                    onPressed: () {
                      ref.read(repositoryActionProvider.notifier).syncRepository(repositoryId);
                    },
                  ),
                ],

                if (permissions.canSyncRepository(repository.projectId) && currentSyncStatus != SyncStatus.syncing) ...[
                  const SizedBox(height: AppSpacing.xl),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Manual Synchronization', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Force an immediate synchronization. GitHub changes are normally synchronized automatically through the configured webhook.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    text: 'Sync Now',
                    icon: Icons.sync,
                    isLoading: actionState.isLoading,
                    onPressed: () {
                      ref.read(repositoryActionProvider.notifier).syncRepository(repositoryId);
                    },
                  ),
                ]
              ],
            ),
          ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: const SkeletonListLoader(count: 4, itemHeight: 90),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ErrorState(
          message: 'Unable to load repository status. Please check your network connection.',
          onRetry: () => ref.invalidate(repositoryDetailsProvider(repositoryId)),
        ),
      ),
    );
  }

  SyncStatus _parseSyncStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS': return SyncStatus.success;
      case 'FAILED': return SyncStatus.failed;
      case 'SYNCING': return SyncStatus.syncing;
      case 'PENDING':
      default: return SyncStatus.pending;
    }
  }

  List<PipelineStage> _buildPipelineStages(SyncStatus status) {
    // Determine stages based on high level SyncStatus since detailed pipeline isn't exposed yet
    PipelineStageStatus getStatusFor(int stepIndex, int currentActiveStep, SyncStatus overalStatus) {
      if (overalStatus == SyncStatus.failed && stepIndex == currentActiveStep) {
        return PipelineStageStatus.failed;
      }
      if (overalStatus == SyncStatus.failed && stepIndex > currentActiveStep) {
        return PipelineStageStatus.notStarted;
      }
      if (stepIndex < currentActiveStep || overalStatus == SyncStatus.success) {
        return PipelineStageStatus.success;
      }
      if (stepIndex == currentActiveStep && overalStatus == SyncStatus.syncing) {
        return PipelineStageStatus.running;
      }
      return PipelineStageStatus.pending;
    }

    // Rough approximation of active step
    int currentStep = 0;
    if (status == SyncStatus.pending) currentStep = 1; // Queued
    if (status == SyncStatus.syncing) currentStep = 2; // Sync Worker (mocking as active)

    return [
      PipelineStage(title: 'Repository', status: getStatusFor(0, currentStep, status)),
      PipelineStage(title: 'Queued', status: getStatusFor(1, currentStep, status)),
      PipelineStage(title: 'Sync Worker', status: getStatusFor(2, currentStep, status)),
      PipelineStage(title: 'Extraction Worker', status: getStatusFor(3, currentStep, status)),
      PipelineStage(title: 'Embedding Worker', status: getStatusFor(4, currentStep, status)),
      PipelineStage(title: 'Knowledge Ready', status: getStatusFor(5, currentStep, status)),
    ];
  }
}
