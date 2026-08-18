import 'package:freezed_annotation/freezed_annotation.dart';

part 'knowledge_stats.freezed.dart';

@freezed
class KnowledgeStats with _$KnowledgeStats {
  const factory KnowledgeStats({
    @Default(0) int totalDocuments,
    @Default(0) int totalRecords,
    @Default(0) int repositoryCount,
    @Default(0) int processingCount,
    @Default(0) int failedCount,
    DateTime? lastIndexed,
  }) = _KnowledgeStats;
}
