import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/repository_providers.dart';
import '../../data/models/repository_dto.dart';

class AddRepositoryScreen extends ConsumerStatefulWidget {
  final String projectId;

  const AddRepositoryScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<AddRepositoryScreen> createState() => _AddRepositoryScreenState();
}

class _AddRepositoryScreenState extends ConsumerState<AddRepositoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final dto = CreateRepositoryDto(
        projectId: widget.projectId,
        repositoryName: _nameController.text.trim(),
        repositoryUrl: _urlController.text.trim(),
        provider: 'GITHUB',
      );

      ref.read(repositoryActionProvider.notifier).createRepository(dto).then((repository) async {
        if (mounted) {
          context.pushReplacement('/repositories/${repository.id}');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(repositoryActionProvider);
    
    ref.listen<AsyncValue<void>>(
      repositoryActionProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add repository: $error')),
            );
          },
        );
      },
    );

    return SaaSLayout(
      title: 'Connect GitHub Repository',
      child: ResponsiveLayout(
        mobile: _buildForm(actionState),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildForm(actionState),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AsyncValue<void> actionState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect a GitHub repository to automatically synchronize code, pull requests, and documentation. You will configure the webhook in the next step.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            AppTextField(
              controller: _nameController,
              labelText: 'Repository Name',
              hintText: 'e.g., Orivox Frontend',
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a repository name';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            
            AppTextField(
              controller: _urlController,
              labelText: 'GitHub URL',
              hintText: 'https://github.com/username/repo',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a repository URL';
                }
                
                final githubUrlRegex = RegExp(r'^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$');
                if (!githubUrlRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid GitHub repository URL';
                }
                
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            
            PrimaryButton(
              text: 'Add Repository',
              isLoading: actionState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
