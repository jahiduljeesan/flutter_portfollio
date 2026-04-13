import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/admin/presentation/pages/login_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
    // errorBuilder: (context, state) => const ErrorPage(),
  );
});
