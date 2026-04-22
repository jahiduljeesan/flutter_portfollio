import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../repositories/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return FirebaseProjectRepository();
});

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getProjects();
});

final projectDetailsProvider = FutureProvider.family<Project, String>((ref, id) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getProjectById(id);
});

final cvProvider = StreamProvider<String?>((ref) {
  return FirebaseFirestore.instance.collection('settings').doc('general').snapshots().map((doc) {
    if (doc.exists) {
      return doc.data()?['cv_url'] as String?;
    }
    return null;
  });
});

final devImageProvider = StreamProvider<String?>((ref) {
  return FirebaseFirestore.instance.collection('settings').doc('general').snapshots().map((doc) {
    if (doc.exists) {
      return doc.data()?['dev_image_url'] as String?;
    }
    return null;
  });
});

