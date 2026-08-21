import 'package:flutter/material.dart';
import '../../../../core/widgets/indicators.dart';
import '../../domain/entities/sync_status.dart';

class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final bool isActive;

  const SyncStatusBadge({
    super.key,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const StatusBadge(
        label: 'Disabled',
        type: StatusType.warning,
      );
    }

    switch (status) {
      case SyncStatus.pending:
        return const StatusBadge(label: 'Waiting to sync', type: StatusType.info);
      case SyncStatus.syncing:
        return const StatusBadge(label: 'Syncing...', type: StatusType.info);
      case SyncStatus.success:
        return const StatusBadge(label: 'Synced', type: StatusType.success);
      case SyncStatus.failed:
        return const StatusBadge(label: 'Sync failed', type: StatusType.error);
    }
  }
}
