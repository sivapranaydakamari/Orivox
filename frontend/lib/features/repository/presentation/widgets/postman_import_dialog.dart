import 'package:flutter/material.dart';

class PostmanImportDialog extends StatefulWidget {
  final String projectId;

  const PostmanImportDialog({super.key, required this.projectId});

  @override
  _PostmanImportDialogState createState() => _PostmanImportDialogState();
}

class _PostmanImportDialogState extends State<PostmanImportDialog> {
  final _jsonController = TextEditingController();
  bool _isUploading = false;

  Future<void> _uploadPostman() async {
    if (_jsonController.text.isEmpty) return;
    
    setState(() => _isUploading = true);
    
    // Simulate API delay for UI prototype
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isUploading = false);
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colors.surface,
      title: Text('Import Postman Collection', style: TextStyle(color: colors.onSurface)),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste your Postman Collection JSON v2.1 below. Secrets will be automatically redacted.',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jsonController,
              maxLines: 10,
              style: TextStyle(color: colors.onSurface, fontFamily: 'monospace', fontSize: 12),
              decoration: InputDecoration(
                hintText: '{\n  "info": {\n    "name": "My API"\n  },\n  "item": []\n}',
                hintStyle: TextStyle(color: colors.onSurfaceVariant.withAlpha(128)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.outline)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary)),
                filled: true,
                fillColor: colors.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: colors.onSurfaceVariant)),
        ),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _uploadPostman,
          icon: _isUploading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
              : const Icon(Icons.cloud_upload),
          label: Text(_isUploading ? 'Ingesting...' : 'Import'),
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.onPrimary),
        ),
      ],
    );
  }
}
