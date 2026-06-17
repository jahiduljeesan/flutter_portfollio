import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/admin/presentation/pages/login_page.dart';
import '../../features/admin/providers/auth_provider.dart';

final adminPathProvider = Provider<String>((ref) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rnd = Random();
  final gibberish = String.fromCharCodes(
    Iterable.generate(16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)))
  );
  return '/$gibberish';
});

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authProvider);
  final adminPath = ref.watch(adminPathProvider);

  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const HomePage(), // Redirect unknown (old gibberish) paths to Home
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      final isAdminPage = state.matchedLocation == adminPath || state.matchedLocation.startsWith('$adminPath/');

      if (isAdminPage && !isAuthenticated) {
        return '/login';
      }
      if (loggingIn && isAuthenticated) {
        return adminPath;
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
        path: adminPath,
        builder: (context, state) => const AdminDashboard(), //dashboard
      ),
    ],
    // errorBuilder: (context, state) => const ErrorPage(),
  );
});
