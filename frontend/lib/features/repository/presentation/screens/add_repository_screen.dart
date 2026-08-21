import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/repository_providers.dart';
import '../../data/models/repository_dto.dart';
import '../../../integration/providers/github_app_providers.dart';
import '../../../integration/data/github_app_api.dart';

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
  int _currentStep = 0; // 0: Connect, 1: Select Repo, 2: Configure
  bool _initialized = false;

  Map<String, dynamic>? _selectedInstallation;
  Map<String, dynamic>? _selectedRepository;

  bool _syncCode = true;
  bool _syncDocs = true;
  bool _syncPrs = false;

  bool _isLaunching = false;

  Future<void> _launchGitHubInstall() async {
    setState(() { _isLaunching = true; });
    try {
      final api = ref.read(githubAppApiProvider);
      final url = await api.getInstallUrl();
      
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please complete the installation in your browser, then click Refresh.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      } else {
        throw Exception('Could not launch browser.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLaunching = false; });
      }
    }
  }

  void _submit() {
    if (_selectedRepository == null || _selectedInstallation == null) return;
    
    final dto = CreateRepositoryDto(
      projectId: widget.projectId,
      repositoryName: _selectedRepository!['name'] as String,
      provider: 'GITHUB',
      githubInstallationId: _selectedInstallation!['installationId'] as String,
      githubRepositoryId: _selectedRepository!['id'] as int,
      githubRepositoryFullName: _selectedRepository!['full_name'] as String,
      sourceConfiguration: SourceConfigurationDto(
        code: _syncCode,
        docs: _syncDocs,
        prs: _syncPrs,
      ),
    );

    ref.read(repositoryActionProvider.notifier).createRepository(dto).then((repository) async {
      if (mounted) {
        context.pushReplacement('/repositories/${repository.id}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(repositoryActionProvider);
    final allRepositoriesAsync = ref.watch(githubAllRepositoriesProvider);
    
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

    // Auto-advance logic
    if (allRepositoriesAsync.hasValue && !_initialized) {
      final installations = allRepositoriesAsync.value!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && installations.isNotEmpty) {
          setState(() {
            _currentStep = 1;
            if (installations.length == 1) {
              _selectedInstallation = installations.first;
            }
            _initialized = true;
          });
        } else if (mounted) {
          setState(() {
            _initialized = true;
          });
        }
      });
    }

    return SaaSLayout(
      title: 'Connect GitHub Repository',
      child: ResponsiveLayout(
        mobile: _buildContent(actionState, allRepositoriesAsync),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildContent(actionState, allRepositoriesAsync),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AsyncValue<void> actionState, AsyncValue<List<Map<String, dynamic>>> allRepositoriesAsync) {
    if (!_initialized && allRepositoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: AppSpacing.xxl),
              if (_currentStep == 0) _buildStep1Connect(),
              if (_currentStep == 1) _buildStep2SelectRepo(allRepositoriesAsync),
              if (_currentStep == 2) _buildStep3Configure(actionState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepIndicator(0, 'Connect GitHub'),
        _buildStepDivider(),
        _buildStepIndicator(1, 'Select Repository'),
        _buildStepDivider(),
        _buildStepIndicator(2, 'Configure Sources'),
      ],
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep >= stepIndex;
    final isCurrent = _currentStep == stepIndex;
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
            child: Text(
              '${stepIndex + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black87 : Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildStep1Connect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Authorize Orivox to access your GitHub repositories.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: PrimaryButton(
            text: 'Install GitHub App',
            icon: Icons.link,
            isLoading: _isLaunching,
            onPressed: _launchGitHubInstall,
          ),
        ),
      ],
    );
  }

  Widget _buildStep2SelectRepo(AsyncValue<List<Map<String, dynamic>>> allRepositoriesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Select an Installation & Repository',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    ref.invalidate(githubAllRepositoriesProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _launchGitHubInstall,
            icon: const Icon(Icons.add),
            label: const Text('Connect Another GitHub Account'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        
        allRepositoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error loading repositories: $err', style: const TextStyle(color: Colors.red)),
          data: (installations) {
            if (installations.isEmpty) {
              return Column(
                children: [
                  const Text('No active installations found. Please connect your GitHub account.'),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    text: 'Install GitHub App',
                    onPressed: _launchGitHubInstall,
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Map<String, dynamic>>(
                  decoration: const InputDecoration(labelText: 'GitHub Account / Organization'),
                  value: _selectedInstallation,
                  items: installations.map((inst) {
                    return DropdownMenuItem(
                      value: inst,
                      child: Text('${inst['githubAccountLogin']} (${inst['githubAccountType']})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedInstallation = val;
                      _selectedRepository = null;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                if (_selectedInstallation != null)
                  _buildRepositoryList(_selectedInstallation!['repositories'] as List),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRepositoryList(List repositories) {
    if (repositories.isEmpty) {
      return const Text('No repositories accessible for this installation.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Repository', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: repositories.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final repo = repositories[index] as Map<String, dynamic>;
              final isSelected = _selectedRepository?['id'] == repo['id'];

              return ListTile(
                title: Text(repo['full_name'] as String),
                subtitle: Text(repo['description'] as String? ?? 'No description', maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                selected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedRepository = repo;
                    _currentStep = 2; // Advance to next step
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Configure(AsyncValue<void> actionState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _currentStep = 1),
            ),
            Text(
              'Configure Sources for ${_selectedRepository?['full_name']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        
        Card(
          elevation: 0,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Source Code'),
                subtitle: const Text('Ingest all source code files for deep technical understanding.'),
                value: _syncCode,
                onChanged: (val) => setState(() => _syncCode = val ?? true),
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Documentation & Specifications'),
                subtitle: const Text('Ingest Markdown docs, OpenAPI specs, and other technical documentation.'),
                value: _syncDocs,
                onChanged: (val) => setState(() => _syncDocs = val ?? true),
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Pull Requests'),
                subtitle: const Text('Ingest PR discussions and resolutions for historical context.'),
                value: _syncPrs,
                onChanged: (val) => setState(() => _syncPrs = val ?? false),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Connect Repository & Start Sync',
            isLoading: actionState.isLoading,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}
