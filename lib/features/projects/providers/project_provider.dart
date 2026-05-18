import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../repositories/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return FirebaseProjectRepository();
});

final List<Project> staticProjects = [
  Project(
    id: 'apexpay',
    title: 'ApexPay - Crypto-Fintech Wallet',
    shortDescription:
        'A sleek, hyper-secure mobile app for atomic cryptocurrency swaps, biometric authentication, and high-yield cold-wallet staking.',
    fullDescription:
        'ApexPay is a next-generation decentralized mobile finance application built using Flutter. It integrates advanced cryptographic pipelines to facilitate instant atomic swaps across multiple chains while ensuring private keys remain locked on-device using secure hardware enclaves.',
    features: [
      'Biometric Cryptographic Verification',
      'Real-Time Atomic Swap Pipeline',
      'Cold-Storage Staking Core',
      'Dynamic HUD Asset Visualization',
    ],
    imageUrls: [
      'https://images.unsplash.com/photo-1621416894569-0f39ed31d247?auto=format&fit=crop&q=80&w=800',
    ],
    coverPhoto:
        'https://images.unsplash.com/photo-1621416894569-0f39ed31d247?auto=format&fit=crop&q=80&w=800',
    viewCount: 1258,
    isFeatured: true,
  ),
  Project(
    id: 'novapulse',
    title: 'NovaPulse - Wearable Bio-Hacker API',
    shortDescription:
        'Next-gen health monitoring and predictive biometrics. Connects to smart rings and watches to map autonomic nervous system metrics.',
    fullDescription:
        'NovaPulse harnesses real-time wearable sensor streams to analyze HRV, body temperature, and sleep cycles. Leveraging specialized background workers and fast local SQLite computation, it delivers precise predictive warnings about incoming physical stress or fatigue.',
    features: [
      'Real-Time HRV Spectral Analysis',
      'Predictive Sleep Phase Modeling',
      'Smart IoT Ring Integrations',
      'High-Performance Local Calculations',
    ],
    imageUrls: [
      'https://images.unsplash.com/photo-1510017808638-f8821d27a50d?auto=format&fit=crop&q=80&w=800',
    ],
    coverPhoto:
        'https://images.unsplash.com/photo-1510017808638-f8821d27a50d?auto=format&fit=crop&q=80&w=800',
    viewCount: 945,
    isFeatured: true,
  ),
  Project(
    id: 'cybergrid',
    title: 'CyberGrid - Decentralized Logistics',
    shortDescription:
        'Autonomous package routing, blockchain-integrated smart-contract billing, and multi-hub real-time spatial package dispatch tracking.',
    fullDescription:
        'CyberGrid is an enterprise logistics framework coordinating autonomous fleet deliveries. By utilizing Flutter on high-performance tablet devices, it plots real-time optimized graph paths while maintaining cryptographically signed blockchain delivery receipts.',
    features: [
      'Autonomous Graph Routing Optimization',
      'Solidity Smart Contract Settlement',
      'Real-Time Spatial Map Telemetry',
      'Offline SQLite Queue Cache',
    ],
    imageUrls: [
      'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80&w=800',
    ],
    coverPhoto:
        'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80&w=800',
    viewCount: 1832,
    isFeatured: true,
  ),
];

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  try {
    final list = await repo.getProjects();
    if (list.isNotEmpty) {
      return list;
    }
  } catch (e) {
    // Fall back to static mock projects
  }
  return staticProjects;
});

final projectDetailsProvider = FutureProvider.family<Project, String>((
  ref,
  id,
) async {
  final repo = ref.watch(projectRepositoryProvider);
  try {
    return await repo.getProjectById(id);
  } catch (e) {
    // If not found in database, check static projects
    final match = staticProjects.where((element) => element.id == id);
    if (match.isNotEmpty) {
      return match.first;
    }
    throw Exception(
      'Project with id $id not found in local or remote repository',
    );
  }
});

final generalSettingsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return FirebaseFirestore.instance
      .collection('settings')
      .doc('general')
      .snapshots()
      .map((doc) {
        if (doc.exists && doc.data() != null) {
          return doc.data()!;
        }
        return {};
      });
});
