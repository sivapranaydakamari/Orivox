import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/job_remote_data_source.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/worker_metric.dart';
import 'repository_providers.dart';

final jobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSource(ref.watch(dioProvider));
});

final jobRepositoryProvider = Provider<JobRepositoryImpl>((ref) {
  return JobRepositoryImpl(ref.watch(jobRemoteDataSourceProvider));
});

final jobDetailsProvider = FutureProvider.family<JobStatus, String>((ref, id) async {
  return ref.watch(jobRepositoryProvider).getJobStatus(id);
});

final workerMetricsProvider = FutureProvider<List<WorkerMetric>>((ref) async {
  return ref.watch(jobRepositoryProvider).getMetrics();
});

class SyncPollingState {
  final Map<String, dynamic> statusData;
  final JobStatus? currentJob;

  SyncPollingState({required this.statusData, this.currentJob});
}

class SyncPollingNotifier extends AutoDisposeFamilyAsyncNotifier<SyncPollingState, String> {
  Timer? _timer;
  bool _isPolling = false;

  @override
  FutureOr<SyncPollingState> build(String arg) async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final state = await _fetchStatus();
    _evaluatePolling(state.statusData['syncStatus']);
    return state;
  }

  Future<SyncPollingState> _fetchStatus() async {
    final statusData = await ref.read(jobRepositoryProvider).getSyncStatus(arg);
    
    // If we have a way to know the current job ID (e.g. if the backend started returning it, 
    // or if we store it in a shared state when triggered), we could fetch job details.
    // Since sync-status endpoint currently returns { syncStatus, lastSuccessfulSync, ... }
    // and doesn't explicitly return jobId yet, we will just return the statusData.
    // In a real scenario, we'd fetch the job here if jobId is known.
    return SyncPollingState(statusData: statusData);
  }

  void _evaluatePolling(String? syncStatus) {
    final shouldPoll = syncStatus == 'SYNCING' || syncStatus == 'PENDING';

    if (shouldPoll && !_isPolling) {
      _startPolling();
    } else if (!shouldPoll && _isPolling) {
      _stopPolling();
    }
  }

  void _startPolling() {
    _isPolling = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final newState = await _fetchStatus();
        state = AsyncValue.data(newState);
        
        // Invalidate repository details so the main screen updates too
        ref.invalidate(repositoryDetailsProvider(arg));

        _evaluatePolling(newState.statusData['syncStatus']);
      } catch (e) {
        // Handle network failure without crashing the stream, maybe backoff
        // For now, if we get an error, we keep polling unless it's a 404
      }
    });
  }

  void _stopPolling() {
    _isPolling = false;
    _timer?.cancel();
  }
}

final syncPollingProvider = AutoDisposeAsyncNotifierProviderFamily<SyncPollingNotifier, SyncPollingState, String>(() {
  return SyncPollingNotifier();
});
