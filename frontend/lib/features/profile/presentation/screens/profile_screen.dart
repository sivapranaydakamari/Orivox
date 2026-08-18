import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: asyncProfile.when(
        data: (user) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text('Account Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/edit'),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/password'),
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text('Active Sessions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/sessions'),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text('App Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme Preferences'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/theme'),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/about'),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(message: 'Loading profile...'),
        error: (e, st) => ErrorState(
          message: 'Failed to load profile: $e',
          onRetry: () => ref.invalidate(profileProvider),
        ),
      ),
    );
  }
}
