enum JobType {
  syncRepository('SYNC_REPOSITORY'),
  extractDocument('EXTRACT_DOCUMENT'),
  generateEmbedding('GENERATE_EMBEDDING'),
  retryFailedDocument('RETRY_FAILED_DOCUMENT'),
  reindexProject('REINDEX_PROJECT');

  final String value;
  const JobType(this.value);

  static JobType? fromValue(String value) {
    for (var type in JobType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
