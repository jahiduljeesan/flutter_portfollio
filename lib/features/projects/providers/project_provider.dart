import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../repositories/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  // Switch to FirebaseProjectRepository when Firebase is configured
  return MockProjectRepository();
});

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getProjects();
});

final projectDetailsProvider = FutureProvider.family<Project, String>((ref, id) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getProjectById(id);
});
