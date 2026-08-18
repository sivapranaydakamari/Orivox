
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/active_project_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/organization/presentation/screens/organization_list_screen.dart';
import '../../features/organization/presentation/screens/organization_details_screen.dart';
import '../../features/organization/presentation/screens/organization_members_screen.dart';
import '../../features/project/presentation/screens/project_list_screen.dart';
import '../../features/project/presentation/screens/project_details_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/repository/presentation/screens/repository_list_screen.dart';
import '../../features/repository/presentation/screens/repository_details_screen.dart';
import '../../features/repository/presentation/screens/add_repository_screen.dart';
import '../../features/repository/presentation/screens/sync_dashboard_screen.dart';
import '../../features/knowledge/presentation/screens/knowledge_dashboard_screen.dart';
import '../../features/knowledge/presentation/screens/document_list_screen.dart';
import '../../features/knowledge/presentation/screens/document_details_screen.dart';
import '../../features/knowledge/presentation/screens/knowledge_record_list_screen.dart';
import '../../features/knowledge/presentation/screens/knowledge_record_details_screen.dart';
import '../../features/chat/presentation/screens/chat_home_screen.dart';
import '../../features/chat/presentation/screens/conversation_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/active_sessions_screen.dart';
import '../../features/profile/presentation/screens/theme_preferences_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';

import 'package:flutter/foundation.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';
      
      final isSplashRoute = state.matchedLocation == '/splash';

      return authState.maybeWhen(
        authenticated: (user) {
          if (isAuthRoute || isSplashRoute || state.matchedLocation == '/') {
            if (user.memberships.isEmpty) {
              return '/organizations';
            } else if (user.memberships.length == 1) {
              return '/dashboard';
            } else {
              return '/organizations';
            }
          }
          return null; // Stay on current protected route
        },
        unauthenticated: () {
          if (!isAuthRoute) {
            return '/login'; // Redirect to login if trying to access protected route
          }
          return null; // Let them stay on auth routes
        },
        loading: () => null,
        error: (_) => '/login', // Fallback to login on error
        orElse: () => null,
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/organizations',
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/organizations',
        builder: (context, state) => const OrganizationListScreen(),
      ),
      GoRoute(
        path: '/organizations/:id',
        builder: (context, state) => OrganizationDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/organizations/:id/members',
        builder: (context, state) => OrganizationMembersScreen(organizationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'password',
            builder: (context, state) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: 'sessions',
            builder: (context, state) => const ActiveSessionsScreen(),
          ),
          GoRoute(
            path: 'theme',
            builder: (context, state) => const ThemePreferencesScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectListScreen(),
      ),
      GoRoute(
        path: '/projects/:id',
        builder: (context, state) => ProjectDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/repositories',
        builder: (context, state) => const RepositoryListScreen(),
      ),
      GoRoute(
        path: '/projects/:projectId/repositories',
        builder: (context, state) => RepositoryListScreen(projectId: state.pathParameters['projectId']),
      ),
      GoRoute(
        path: '/projects/:projectId/repositories/new',
        builder: (context, state) => AddRepositoryScreen(projectId: state.pathParameters['projectId']!),
      ),
      GoRoute(
        path: '/repositories/:id',
        builder: (context, state) => RepositoryDetailsScreen(repositoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/repositories/:id/sync-dashboard',
        builder: (context, state) => SyncDashboardScreen(repositoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/knowledge',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'] ?? ''; // Need context to get current project if not passed, but for now we expect it in query
          return KnowledgeDashboardScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/knowledge/records',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'] ?? '';
          return KnowledgeRecordListScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/knowledge/records/:id',
        builder: (context, state) => KnowledgeRecordDetailsScreen(recordId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/documents',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'] ?? '';
          return DocumentListScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/documents/:id',
        builder: (context, state) => DocumentDetailsScreen(documentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          return const ChatHomeScreen();
        },
      ),
      GoRoute(
        path: '/chat/new',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'] ?? ref.read(activeProjectProvider) ?? '';
          return ConversationScreen(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'] ?? ref.read(activeProjectProvider) ?? '';
          return ConversationScreen(
            projectId: projectId,
            conversationId: state.pathParameters['id'],
          );
        },
      ),
    ],
  );
});
