import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'organization_switcher.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/active_org_provider.dart';
import '../providers/permissions_provider.dart';

class SaaSLayout extends ConsumerWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showProjectSelector;

  const SaaSLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.showProjectSelector = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final activeOrgId = ref.watch(activeOrgProvider);
    final permissions = ref.watch(permissionsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        final workspaceNavItems = [
          _NavItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
            isSelected: currentPath.startsWith('/dashboard'),
          ),
          _NavItem(
            icon: Icons.folder_outlined,
            selectedIcon: Icons.folder,
            label: 'Projects',
            route: '/projects',
            isSelected: currentPath.startsWith('/projects'),
          ),
        ];

        final intelligenceNavItems = [
          _NavItem(
            icon: Icons.auto_awesome_outlined,
            selectedIcon: Icons.auto_awesome,
            label: 'AI Assistant',
            route: '/chat',
            isSelected: currentPath.startsWith('/chat'),
          ),
          _NavItem(
            icon: Icons.article_outlined,
            selectedIcon: Icons.article,
            label: 'Knowledge Base',
            route: '/knowledge',
            isSelected: currentPath.startsWith('/knowledge'),
          ),
          _NavItem(
            icon: Icons.find_in_page_outlined,
            selectedIcon: Icons.find_in_page,
            label: 'Documents',
            route: '/documents',
            isSelected: currentPath.startsWith('/documents'),
          ),
        ];

        Widget buildNavSection(String sectionTitle, List<_NavItem> items) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
                child: Text(
                  sectionTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              for (final item in items)
                ListTile(
                  leading: Icon(item.isSelected ? item.selectedIcon : item.icon, color: item.isSelected ? Theme.of(context).colorScheme.primary : null),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: item.isSelected ? FontWeight.bold : FontWeight.normal,
                      color: item.isSelected ? Theme.of(context).colorScheme.primary : null,
                      fontSize: 14,
                    ),
                  ),
                  selected: item.isSelected,
                  selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onTap: () {
                    if (!isDesktop) Navigator.of(context).pop();
                    context.go(item.route);
                  },
                ),
            ],
          );
        }

        final drawerContent = Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Icon(Icons.hub_outlined, color: Colors.blueAccent, size: 26),
                    SizedBox(width: 10),
                    Text(
                      'Orivox',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  buildNavSection('Workspace', workspaceNavItems),
                  buildNavSection('Intelligence', intelligenceNavItems),
                  const Divider(height: 32),
                  if (permissions.isOrgAdmin && activeOrgId != null)
                    ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: const Text('Organization Settings', style: TextStyle(fontSize: 14)),
                      onTap: () {
                        if (!isDesktop) Navigator.of(context).pop();
                        context.push('/organizations/$activeOrgId/members');
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profile & Settings', style: TextStyle(fontSize: 14)),
                    onTap: () {
                      if (!isDesktop) Navigator.of(context).pop();
                      context.push('/profile');
                    },
                  ),
                ],
              ),
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !isDesktop,
            title: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: OrganizationSwitcher(),
              ),
            ),
            actions: [
              ...?actions,
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle_outlined, size: 26),
                tooltip: 'User Menu',
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Log out', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authNotifierProvider.notifier).logout();
                  } else if (value == 'profile') {
                    context.push('/profile');
                  }
                },
              ),
              const SizedBox(width: 12),
            ],
          ),
          drawer: isDesktop ? null : Drawer(child: drawerContent),
          body: Row(
            children: [
              if (isDesktop)
                SizedBox(
                  width: 240,
                  child: Material(
                    elevation: 1,
                    child: drawerContent,
                  ),
                ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AppBreadcrumbBanner(currentPath: currentPath, title: title),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final bool isSelected;

  _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    required this.isSelected,
  });
}

class _AppBreadcrumbBanner extends StatelessWidget {
  final String currentPath;
  final String title;

  const _AppBreadcrumbBanner({
    required this.currentPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPath == '/dashboard') return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withAlpha(50))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/dashboard'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  'Workspace',
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right, size: 14, color: Colors.grey),
          ),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
