import '../models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProjectById(String id);
  Future<void> addProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}

class MockProjectRepository implements ProjectRepository {
  final List<Project> _projects = [
    Project(
      id: '1',
      title: 'Lumina Banking',
      shortDescription: 'A high-performance digital banking suite with real-time biometric security and custom Canvas-based visualization engines.',
      fullDescription: 'Lumina Banking is a full-fledged fintech application designed to provide secure, real-time banking experiences. We focused on seamless biometric auth and performance, ensuring that millions of transactions are handled efficiently. The UI is built entirely from scratch with custom Canvas painting for graphs.',
      features: [
        'Real-time transaction processing',
        'Biometric Auth (FaceID / Fingerprint)',
        'Canvas-based dynamic charts',
        'Offline capability with local caching',
      ],
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDD61Bz0GAGsILLZr8QQUsvT1VD-Wb9vm8oYBrveMwegZmJ9yPV5taF3BOBPB4XwGDo6jiLz7Th3Jn9EWBqbExc1Zw6tqPqb8Lubx7Dj8hRkJTNLlQ1iUxKZfOHBDpe-IVBKkxKf2jI3CLNKUW3jzh0K-kxPj58JoVZXB3mHB2QJCe43Z1ziJ6WtGGJVXEvneHYCfNrPnhNYKuS5-sVaYT_VsvkKcSg2Bq2s8j9oUV2ycDr87hE_guhL38EuCDq86NMXAYgPmXmjSU',
      ],
      isFeatured: true,
      viewCount: 1540,
    ),
    Project(
      id: '2',
      title: 'VitalPulse AI',
      shortDescription: 'Enterprise-level health tracking integration using Bluetooth Low Energy (BLE) and predictive analysis with ML Kit.',
      fullDescription: 'VitalPulse handles complex BLE connections to medical devices and runs ML models on-device to predict health anomalies. Designed to be a life-saving tool, UI/UX was paramount to ensure critical info is always visible immediately.',
      features: [
        'BLE Device Integration',
        'On-device MLKit inferences',
        'Real-time heart rate monitoring',
        'Cloud syncing and reporting',
      ],
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAceOnpR5gvWMCIB559m5VqXh1xBmIzbgaCRM7U9TkHJwSOmvxtXshpNC5QCb4DFC7gmj6TiOxN5dTVEglHz6OB7Qd-Gg3tPSLc8hBEBa4rIjGo1u8B7-QUh9ZOtxVxpwxVce4lxaizTzFe8Hr6Ojs0TA-ax9M-Cvtpix1N74D04JhLw9ZLZFyt5KcUvAFYDMrJ6an4Z2y3oaCJsG-nfaI7JNqVnOJaLVsPF3jvjkAdx08tIsZhkSOz94hH-lnP-xr6K-XPclvvxw0',
      ],
      isFeatured: true,
      viewCount: 2310,
    ),
  ];

  @override
  Future<void> addProject(Project project) async {
    await Future.delayed(const Duration(seconds: 1));
    _projects.add(project);
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _projects.removeWhere((p) => p.id == id);
  }

  @override
  Future<Project> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _projects.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<Project>> getProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return _projects;
  }

  @override
  Future<void> updateProject(Project project) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
    }
  }
}
