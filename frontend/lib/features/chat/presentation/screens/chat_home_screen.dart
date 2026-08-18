import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/widgets/skeleton_loaders.dart';
import '../../../../core/providers/active_project_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../providers/chat_providers.dart';
import '../../domain/entities/chat_models.dart';

class ChatHomeScreen extends ConsumerWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectId = ref.watch(activeProjectProvider);
    final projectsAsync = ref.watch(projectListProvider);

    if (projectId == null) {
      final projects = projectsAsync.valueOrNull;
      if (projects != null && projects.isNotEmpty) {
        final firstId = projects.first.id;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(activeProjectProvider.notifier).setProject(firstId);
        });
        return const SaaSLayout(
          title: 'AI Assistant',
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return SaaSLayout(
        title: 'AI Assistant',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EmptyState(
                title: 'No Workspace Project Found',
                message: 'Please create a project first before starting an AI Assistant conversation.',
                icon: Icons.chat_bubble_outline,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Go to Projects'),
                onPressed: () => context.push('/projects'),
              ),
            ],
          ),
        ),
      );
    }

    final asyncConversations = ref.watch(conversationsProvider);

    return SaaSLayout(
      title: 'AI Assistant',
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          tooltip: 'Clear History',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Clear History',
                message: 'Are you sure you want to delete all conversations? This cannot be undone.',
                confirmText: 'Clear',
                onConfirm: () {
                  Navigator.pop(context);
                  ref.read(conversationsProvider.notifier).clearAll();
                },
                onCancel: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI Assistant', style: Theme.of(context).textTheme.headlineMedium),
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/chat/new');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Chat'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            asyncConversations.when(
              data: (conversations) {
                if (conversations.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No Conversations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Start a new chat to interact with the AI Assistant.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
                        title: Text(conv.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(DateFormat.yMMMd().add_jm().format(conv.updatedAt.toLocal())),
                        onTap: () {
                          context.push('/chat/${conv.id}');
                        },
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'rename') {
                              _showRenameDialog(context, ref, conv);
                            } else if (value == 'delete') {
                              ref.read(conversationsProvider.notifier).deleteConversation(conv.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'rename',
                              child: Text('Rename'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const SkeletonListLoader(count: 3, itemHeight: 70),
              error: (error, stack) => ErrorState(
                message: 'Failed to load conversations: $error',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Conversation conv) {
    final controller = TextEditingController(text: conv.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.trim().isNotEmpty) {
                ref.read(conversationsProvider.notifier).renameConversation(conv.id, controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }
}
