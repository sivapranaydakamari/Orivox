import 'package:flutter/material.dart';
import '../../../../core/network/api_error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/organization_provider.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/widgets/indicators.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/inputs.dart';
import '../../../../core/theme/app_spacing.dart';

class OrganizationDetailsScreen extends ConsumerWidget {
  final String id;
  const OrganizationDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationsState = ref.watch(organizationListProvider);
    final permissions = ref.watch(permissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Details'),
        actions: [
          if (permissions.canDeleteOrganization)
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                ref.read(organizationListProvider.notifier).deleteOrganization(id);
                context.pop();
              },
            ),
        ],
      ),
      body: organizationsState.when(
        data: (organizations) {
          final org = organizations.firstWhere(
            (o) => o.id == id,
            orElse: () => throw Exception('Organization not found'),
          );

          final nameController = TextEditingController(text: org.name);

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  labelText: 'Name',
                  controller: nameController,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Slug: ${org.slug}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.xl),
                if (permissions.canCreateOrganization) // Assuming same permission to update
                  PrimaryButton(
                    text: 'Update Organization',
                    onPressed: () {
                      ref.read(organizationListProvider.notifier).updateOrganization(
                            id,
                            nameController.text,
                          );
                      context.pop();
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingWidget(message: 'Loading...')),
        error: (error, stack) => ErrorState(message: ApiErrorHandler.getMessage(error)),
      ),
    );
  }
}
