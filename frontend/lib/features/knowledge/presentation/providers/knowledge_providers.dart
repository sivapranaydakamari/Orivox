import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/knowledge_remote_data_source.dart';
import '../../data/repositories/knowledge_repository_impl.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/knowledge_record.dart';
import '../../domain/entities/knowledge_stats.dart';

final knowledgeRemoteDataSourceProvider = Provider<KnowledgeRemoteDataSource>((ref) {
  return KnowledgeRemoteDataSource(ref.watch(dioProvider));
});

final knowledgeRepositoryProvider = Provider<KnowledgeRepositoryImpl>((ref) {
  return KnowledgeRepositoryImpl(ref.watch(knowledgeRemoteDataSourceProvider));
});

// RAW LISTS
final rawDocumentListProvider = FutureProvider.family<List<AppDocument>, String?>((ref, projectId) async {
  return ref.watch(knowledgeRepositoryProvider).getDocuments(projectId);
});

final rawKnowledgeRecordListProvider = FutureProvider.family<List<KnowledgeRecord>, String?>((ref, projectId) async {
  return ref.watch(knowledgeRepositoryProvider).getKnowledgeRecords(projectId);
});

// SINGLE ITEMS
final documentDetailsProvider = FutureProvider.autoDispose.family<AppDocument, String>((ref, id) async {
  return ref.watch(knowledgeRepositoryProvider).getDocumentById(id);
});

final knowledgeRecordDetailsProvider = FutureProvider.autoDispose.family<KnowledgeRecord, String>((ref, id) async {
  return ref.watch(knowledgeRepositoryProvider).getKnowledgeRecordById(id);
});

// FILTERS
class DocumentFilter {
  final String searchQuery;
  final String? status;
  final String? sourceType;

  const DocumentFilter({this.searchQuery = '', this.status, this.sourceType});

  DocumentFilter copyWith({String? searchQuery, String? status, String? sourceType}) {
    return DocumentFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      sourceType: sourceType ?? this.sourceType,
    );
  }
}

class DocumentFilterNotifier extends StateNotifier<DocumentFilter> {
  DocumentFilterNotifier() : super(const DocumentFilter());
  
  void updateQuery(String query) => state = state.copyWith(searchQuery: query);
  void updateStatus(String? status) => state = state.copyWith(status: status);
  void updateSourceType(String? sourceType) => state = state.copyWith(sourceType: sourceType);
}

final documentFilterProvider = StateNotifierProvider<DocumentFilterNotifier, DocumentFilter>((ref) {
  return DocumentFilterNotifier();
});

class KnowledgeFilter {
  final String searchQuery;
  final String? status;
  final String? sourceType;
  final String? confidence;

  const KnowledgeFilter({this.searchQuery = '', this.status, this.sourceType, this.confidence});

  KnowledgeFilter copyWith({String? searchQuery, String? status, String? sourceType, String? confidence}) {
    return KnowledgeFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      sourceType: sourceType ?? this.sourceType,
      confidence: confidence ?? this.confidence,
    );
  }
}

class KnowledgeFilterNotifier extends StateNotifier<KnowledgeFilter> {
  KnowledgeFilterNotifier() : super(const KnowledgeFilter());
  
  void updateQuery(String query) => state = state.copyWith(searchQuery: query);
  void updateStatus(String? status) => state = state.copyWith(status: status);
  void updateSourceType(String? sourceType) => state = state.copyWith(sourceType: sourceType);
  void updateConfidence(String? confidence) => state = state.copyWith(confidence: confidence);
}

final knowledgeFilterProvider = StateNotifierProvider<KnowledgeFilterNotifier, KnowledgeFilter>((ref) {
  return KnowledgeFilterNotifier();
});

// FILTERED LISTS
final filteredDocumentListProvider = Provider.family<AsyncValue<List<AppDocument>>, String?>((ref, projectId) {
  final asyncDocs = ref.watch(rawDocumentListProvider(projectId));
  final filter = ref.watch(documentFilterProvider);

  return asyncDocs.whenData((docs) {
    return docs.where((doc) {
      if (filter.status != null && filter.status!.isNotEmpty && doc.status != filter.status) return false;
      if (filter.sourceType != null && filter.sourceType!.isNotEmpty && doc.sourceType != filter.sourceType) return false;
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        if (!doc.title.toLowerCase().contains(query) && !doc.rawContent.toLowerCase().contains(query)) return false;
      }
      return true;
    }).toList();
  });
});

final filteredKnowledgeRecordListProvider = Provider.family<AsyncValue<List<KnowledgeRecord>>, String?>((ref, projectId) {
  final asyncRecords = ref.watch(rawKnowledgeRecordListProvider(projectId));
  final filter = ref.watch(knowledgeFilterProvider);

  return asyncRecords.whenData((records) {
    return records.where((record) {
      if (filter.status != null && filter.status!.isNotEmpty && record.embeddingStatus != filter.status) return false;
      if (filter.sourceType != null && filter.sourceType!.isNotEmpty && record.sourceType != filter.sourceType) return false;
      if (filter.confidence != null && filter.confidence!.isNotEmpty && record.confidence.toString() != filter.confidence) return false;
      
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        if (!record.title.toLowerCase().contains(query) && !record.summary.toLowerCase().contains(query)) return false;
      }
      return true;
    }).toList();
  });
});

// STATS
final knowledgeDashboardStatsProvider = Provider.family<AsyncValue<KnowledgeStats>, String?>((ref, projectId) {
  final docsAsync = ref.watch(rawDocumentListProvider(projectId));
  final recordsAsync = ref.watch(rawKnowledgeRecordListProvider(projectId));

  if (docsAsync.isLoading || recordsAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (docsAsync.hasError) return AsyncValue.error(docsAsync.error!, docsAsync.stackTrace!);
  if (recordsAsync.hasError) return AsyncValue.error(recordsAsync.error!, recordsAsync.stackTrace!);

  final docs = docsAsync.value!;
  final records = recordsAsync.value!;

  int processing = 0;
  int failed = 0;
  final repositories = <String>{};
  DateTime? lastIndexed;

  for (final doc in docs) {
    if (doc.status == 'PENDING' || doc.status == 'EXTRACTING') processing++;
    if (doc.status == 'FAILED') failed++;
    if (doc.metadata?['repositoryId'] != null) repositories.add(doc.metadata!['repositoryId'].toString());
  }

  for (final rec in records) {
    if (rec.embeddingStatus == 'PENDING' || rec.embeddingStatus == 'EMBEDDING') processing++;
    if (rec.embeddingStatus == 'FAILED') failed++;
    
    if (rec.embeddingStatus == 'EMBEDDED' || rec.embeddingStatus == 'COMPLETED') { // Wait, model says EMBEDDED
       if (lastIndexed == null || rec.updatedAt.isAfter(lastIndexed)) {
         lastIndexed = rec.updatedAt;
       }
    }
  }

  return AsyncValue.data(KnowledgeStats(
    totalDocuments: docs.length,
    totalRecords: records.length,
    repositoryCount: repositories.length,
    processingCount: processing,
    failedCount: failed,
    lastIndexed: lastIndexed,
  ));
});

class CreateDocumentNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  CreateDocumentNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> createDocument(String title, String content, String projectId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _ref.read(knowledgeRepositoryProvider).createDocument(title, content, projectId);
      _ref.invalidate(rawDocumentListProvider(projectId));
      _ref.invalidate(rawKnowledgeRecordListProvider(projectId));
    });
  }
}

final createDocumentActionProvider = StateNotifierProvider<CreateDocumentNotifier, AsyncValue<void>>((ref) {
  return CreateDocumentNotifier(ref);
});
