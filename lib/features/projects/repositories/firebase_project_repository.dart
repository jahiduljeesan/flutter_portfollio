import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import 'project_repository.dart';

class FirebaseProjectRepository implements ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'projects';

  @override
  Future<void> addProject(Project project) async {
    final docRef = _firestore.collection(_collectionPath).doc();
    final newProject = Project(
      id: docRef.id,
      title: project.title,
      shortDescription: project.shortDescription,
      fullDescription: project.fullDescription,
      features: project.features,
      imageUrls: project.imageUrls,
      sourceCodeLink: project.sourceCodeLink,
      downloadLink: project.downloadLink,
      isFeatured: project.isFeatured,
      viewCount: project.viewCount,
    );
    await docRef.set(newProject.toMap());
  }

  @override
  Future<void> deleteProject(String id) async {
    await _firestore.collection(_collectionPath).doc(id).delete();
  }

  @override
  Future<Project> getProjectById(String id) async {
    final docSnapshot = await _firestore.collection(_collectionPath).doc(id).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      return Project.fromMap(docSnapshot.data()!, docSnapshot.id);
    }
    throw Exception('Project not found');
  }

  @override
  Future<List<Project>> getProjects() async {
    final querySnapshot = await _firestore.collection(_collectionPath).get();
    return querySnapshot.docs
        .map((doc) => Project.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> updateProject(Project project) async {
    await _firestore.collection(_collectionPath).doc(project.id).update(project.toMap());
  }
}
