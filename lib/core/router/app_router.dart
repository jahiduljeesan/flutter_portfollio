import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/admin/presentation/pages/login_page.dart';
import '../../features/admin/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      final isAdminPage = state.matchedLocation == '/admin' || state.matchedLocation.startsWith('/admin/');

      if (isAdminPage && !isAuthenticated) {
        return '/login';
      }
      if (loggingIn && isAuthenticated) {
        return '/admin';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProjectDetailsPage(projectId: id);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(), //login page
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(), //dashboard
      ),
    ],
    // errorBuilder: (context, state) => const ErrorPage(),
  );
});
