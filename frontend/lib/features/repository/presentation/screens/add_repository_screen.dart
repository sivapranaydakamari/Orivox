import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/saas_layout.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/network/api_error_handler.dart';
import '../providers/repository_providers.dart';
import '../../data/models/repository_dto.dart';
import '../../../integration/providers/github_app_providers.dart';
import '../../../integration/data/github_app_api.dart';

enum GitHubConnectionState {
  checkingConnection,
  notConnected,
  loadingRepositories,
  noRepositories,
  fetchFailed,
  repositoriesLoaded
}

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
  GitHubConnectionState _connectionState = GitHubConnectionState.checkingConnection;
  String? _errorMessage;
  List<Map<String, dynamic>> _installations = [];

  Map<String, dynamic>? _selectedInstallation;
  Map<String, dynamic>? _selectedRepository;

  bool _syncCode = true;
  bool _syncDocs = true;
  bool _syncPrs = false;

  bool _isLaunching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInstallationAndLoadRepositories();
    });
  }

  Future<void> _checkInstallationAndLoadRepositories() async {
    if (!mounted) return;
    setState(() {
      _connectionState = GitHubConnectionState.checkingConnection;
      _errorMessage = null;
    });

    try {
      final installations = await ref.read(githubAllRepositoriesProvider.future);
      if (!mounted) return;

      if (installations.isEmpty) {
        setState(() {
          _connectionState = GitHubConnectionState.notConnected;
        });
      } else {
        bool hasAnyRepos = installations.any((inst) => (inst['repositories'] as List?)?.isNotEmpty ?? false);
        setState(() {
          _installations = installations;
          _selectedInstallation = installations.length == 1 ? installations.first : null;
          _connectionState = hasAnyRepos 
              ? GitHubConnectionState.repositoriesLoaded 
              : GitHubConnectionState.noRepositories;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = ApiErrorHandler.getMessage(e);
        _connectionState = GitHubConnectionState.fetchFailed;
      });
    }
  }

  Future<void> _launchGitHubInstall() async {
    setState(() { _isLaunching = true; _errorMessage = null; });
    try {
      final api = ref.read(githubAppApiProvider);
      final url = await api.getInstallUrl();
      
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        // We do not show SnackBar here; user returns and clicks Refresh
      } else {
        setState(() {
          _errorMessage = 'Could not launch browser to connect GitHub.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ApiErrorHandler.getMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() { _isLaunching = false; });
      }
    }
  }

  void _submit() {
    if (_selectedRepository == null || _selectedInstallation == null) return;
    setState(() { _errorMessage = null; });
    
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
      // Background sync trigger happens in backend automatically via PENDING state + 202
      if (mounted) {
        context.pushReplacement('/repositories/${repository.id}');
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _errorMessage = ApiErrorHandler.getMessage(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionsProvider);
    final actionState = ref.watch(repositoryActionProvider);
    final canConnect = permissions.canCreateRepository(widget.projectId);

    return SaaSLayout(
      title: 'GitHub Integration',
      child: ResponsiveLayout(
        mobile: _buildContent(canConnect, actionState),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildContent(canConnect, actionState),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool canConnect, AsyncValue<void> actionState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorizationCard(canConnect),
          const SizedBox(height: AppSpacing.lg),
          _buildGitHubConnectionCard(),
          const SizedBox(height: AppSpacing.lg),
          if (_connectionState == GitHubConnectionState.repositoriesLoaded || _selectedRepository != null)
            _buildRepositorySelectionCard(canConnect, actionState),
        ],
      ),
    );
  }

  Widget _buildAuthorizationCard(bool canConnect) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Permission', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  canConnect ? Icons.check_circle : Icons.lock,
                  color: canConnect ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    canConnect 
                      ? 'You have Project Manager permission to connect repositories.'
                      : 'You can view repositories, but you need Project Manager permission to connect one.',
                    style: TextStyle(color: canConnect ? Colors.green.shade700 : Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubConnectionCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GitHub Connection', style: Theme.of(context).textTheme.titleMedium),
                if (_connectionState != GitHubConnectionState.checkingConnection)
                  TextButton.icon(
                    onPressed: _checkInstallationAndLoadRepositories,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh Repositories'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            if (_errorMessage != null && _connectionState == GitHubConnectionState.fetchFailed)
              _buildErrorBanner(_errorMessage!, _checkInstallationAndLoadRepositories),

            if (_errorMessage != null && _isLaunching)
              _buildErrorBanner(_errorMessage!, _launchGitHubInstall),

            _buildConnectionStateUi(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message, VoidCallback onRetry) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.red.shade900)),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStateUi() {
    switch (_connectionState) {
      case GitHubConnectionState.checkingConnection:
        return Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: AppSpacing.md),
            Text('Checking GitHub connection...', style: TextStyle(color: Colors.grey.shade700)),
          ],
        );
      case GitHubConnectionState.notConnected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orivox is not connected to any GitHub account for this organization.'),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: 'Install GitHub App',
              icon: Icons.link,
              isLoading: _isLaunching,
              onPressed: _launchGitHubInstall,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: _showReconcileDialog,
              icon: const Icon(Icons.build, size: 18),
              label: const Text('Advanced: Link Existing Installation ID'),
            ),
          ],
        );
      case GitHubConnectionState.loadingRepositories:
        return Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: AppSpacing.md),
            Text('Fetching repositories from GitHub...', style: TextStyle(color: Colors.grey.shade700)),
          ],
        );
      case GitHubConnectionState.noRepositories:
      case GitHubConnectionState.repositoriesLoaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: AppSpacing.sm),
                Text('Connected', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                if (_installations.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: Text('@${_installations.first['githubAccountLogin']}'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: _launchGitHubInstall,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Connect Another GitHub Account'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: _showReconcileDialog,
              icon: const Icon(Icons.build, size: 18),
              label: const Text('Advanced: Link Existing Installation ID'),
            ),
          ],
        );
      case GitHubConnectionState.fetchFailed:
        return const SizedBox.shrink(); // Error banner displayed above
    }
  }

  Future<void> _showReconcileDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link Existing Installation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('If you already installed the GitHub App but it is not showing up, enter the Installation ID from your GitHub App settings URL (e.g. 154716160).'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Installation ID'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Link')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _isLaunching = true;
        _errorMessage = null;
      });
      try {
        await ref.read(githubAppApiProvider).reconcileInstallation(result.trim());
        await _checkInstallationAndLoadRepositories();
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = ApiErrorHandler.getMessage(e);
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLaunching = false;
          });
        }
      }
    }
  }

  Widget _buildRepositorySelectionCard(bool canConnect, AsyncValue<void> actionState) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Repositories', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            
            if (_connectionState == GitHubConnectionState.noRepositories)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Text('No repositories are available. Ensure the GitHub App has access to your repositories.'),
              )
            else ...[
              if (_installations.length > 1) ...[
                DropdownButtonFormField<Map<String, dynamic>>(
                  decoration: const InputDecoration(labelText: 'GitHub Account'),
                  value: _selectedInstallation,
                  items: _installations.map((inst) {
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
                const SizedBox(height: AppSpacing.md),
              ],

              if (_selectedInstallation != null)
                _buildRepositoryList(_selectedInstallation!['repositories'] as List),
              
              if (_selectedRepository != null) ...[
                const SizedBox(height: AppSpacing.xl),
                Text('Configure Sources', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
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
                        onChanged: canConnect ? (val) => setState(() => _syncCode = val ?? true) : null,
                      ),
                      const Divider(height: 1),
                      CheckboxListTile(
                        title: const Text('Documentation & Specifications'),
                        subtitle: const Text('Ingest Markdown docs, OpenAPI specs, and other technical documentation.'),
                        value: _syncDocs,
                        onChanged: canConnect ? (val) => setState(() => _syncDocs = val ?? true) : null,
                      ),
                      const Divider(height: 1),
                      CheckboxListTile(
                        title: const Text('Pull Requests'),
                        subtitle: const Text('Ingest PR discussions and resolutions for historical context.'),
                        value: _syncPrs,
                        onChanged: canConnect ? (val) => setState(() => _syncPrs = val ?? false) : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                if (_errorMessage != null && actionState.hasError)
                  _buildErrorBanner(_errorMessage!, _submit),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Connect Repository',
                    isLoading: actionState.isLoading,
                    onPressed: canConnect ? _submit : null,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoryList(List repositories) {
    if (repositories.isEmpty) {
      return const Text('No repositories accessible for this account.');
    }

    return Container(
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
              });
            },
          );
        },
      ),
    );
  }
}
