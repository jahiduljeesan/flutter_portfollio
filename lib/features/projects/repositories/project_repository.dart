import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProjectById(String id);
  Future<void> addProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}

class FirebaseProjectRepository implements ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'projects';

  @override
  Future<List<Project>> getProjects() async {
    final snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => Project.fromMap(doc.data(), doc.id)).toList();
  }

  @override
  Future<Project> getProjectById(String id) async {
    final doc = await _firestore.collection(_collectionName).doc(id).get();
    if (!doc.exists) throw Exception('Project not found');
    return Project.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> addProject(Project project) async {
    await _firestore.collection(_collectionName).add(project.toMap());
  }

  @override
  Future<void> updateProject(Project project) async {
    await _firestore.collection(_collectionName).doc(project.id).update(project.toMap());
  }

  @override
  Future<void> deleteProject(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}
