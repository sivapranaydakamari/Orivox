import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/indicators.dart';
import '../../domain/entities/chat_models.dart';

class EvidencePanel extends StatelessWidget {
  final List<String> rawSources;

  const EvidencePanel({
    super.key,
    required this.rawSources,
  });

  List<ParsedSource> _parseSources() {
    final List<ParsedSource> parsed = [];
    final RegExp regex = RegExp(r'\[Source \d+\] (.*?) - (.*?) \(ID: (.*?)\) - Relevance: (.*?)\%');

    for (final raw in rawSources) {
      final match = regex.firstMatch(raw);
      if (match != null && match.groupCount >= 4) {
        parsed.add(ParsedSource(
          sourceType: match.group(1) ?? 'Unknown',
          repository: match.group(2) ?? 'Unknown',
          id: match.group(3) ?? '',
          similarityScore: double.tryParse(match.group(4) ?? '0') ?? 0.0,
          rawCitation: raw,
        ));
      } else {
        // Fallback for unexpected formats
        parsed.add(ParsedSource(
          sourceType: 'Unknown',
          repository: 'Unknown',
          id: '',
          similarityScore: 0.0,
          rawCitation: raw,
        ));
      }
    }
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final sources = _parseSources();

    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        'Evidence (${sources.length})',
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      childrenPadding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      children: sources.map((source) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
          elevation: 0,
          child: InkWell(
            onTap: source.id.isNotEmpty
                ? () {
                    // Navigate to appropriate screen based on SourceType
                    // Assuming Document vs Knowledge Record routing depending on what the ID points to.
                    // The backend currently ties most evidence to KnowledgeRecord IDs in this format.
                    // If SourceType == MARKDOWN, we might route to document or knowledge record.
                    // For now, we will route to knowledge record details since evidence is knowledge records.
                    context.push('/knowledge/records/${source.id}');
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(
                        label: source.sourceType,
                        type: StatusType.info,
                      ),
                      const Spacer(),
                      Text(
                        'Relevance: ${source.similarityScore}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: source.similarityScore > 80 
                              ? Colors.green 
                              : source.similarityScore > 50 
                                  ? Colors.orange 
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Repository: ${source.repository}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (source.id.isEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      source.rawCitation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
