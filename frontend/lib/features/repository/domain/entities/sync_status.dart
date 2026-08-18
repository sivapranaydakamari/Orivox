import 'package:freezed_annotation/freezed_annotation.dart';

enum SyncStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('SYNCING')
  syncing,
  @JsonValue('SUCCESS')
  success,
  @JsonValue('FAILED')
  failed;

  String get displayName {
    switch (this) {
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.syncing:
        return 'Syncing';
      case SyncStatus.success:
        return 'Success';
      case SyncStatus.failed:
        return 'Failed';
    }
  }
}
