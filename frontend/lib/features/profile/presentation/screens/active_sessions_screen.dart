import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/indicators.dart';
import '../providers/profile_providers.dart';

class ActiveSessionsScreen extends ConsumerWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSessions = ref.watch(sessionsProvider);
    final actionState = ref.watch(profileActionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout All Other Devices',
            onPressed: actionState.isLoading ? null : () async {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: 'Logout All Devices',
                  message: 'Are you sure you want to log out from all other devices? This will not log you out of your current session.',
                  confirmText: 'Logout All',
                  onConfirm: () async {
                    Navigator.pop(context);
                    try {
                      await ref.read(profileActionProvider.notifier).logoutAllDevices();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All other devices logged out.')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ApiErrorHandler.getMessage(e))));
                      }
                    }
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              );
            },
          ),
        ],
      ),
      body: asyncSessions.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const EmptyState(
              title: 'No Sessions',
              message: 'There are no active sessions for your account.',
              icon: Icons.devices_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.device_hub)),
                  title: Text(session.deviceName ?? 'Unknown Device'),
                  subtitle: Text(
                    '${session.platform ?? 'Unknown OS'} • ${session.ipAddress ?? 'Unknown IP'}\n'
                    'Last used: ${DateFormat.yMMMd().add_jm().format(session.lastUsedAt.toLocal())}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Loading sessions...'),
        error: (e, st) => ErrorState(
          message: 'Failed to load sessions: ${ApiErrorHandler.getMessage(e)}',
          onRetry: () => ref.invalidate(sessionsProvider),
        ),
      ),
    );
  }
}
