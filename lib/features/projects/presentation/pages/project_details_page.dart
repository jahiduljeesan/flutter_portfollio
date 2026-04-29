import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/project_provider.dart';

class ProjectDetailsPage extends ConsumerWidget {
  final String projectId;
  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectDetailsProvider(projectId));

    return Scaffold(
      backgroundColor: AppTheme.surfaceContainerLowestWith(context),
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLowestWith(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go('/'),
        ),
        title: projectAsync.when(
          data: (project) => Text(
            project.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          loading: () => const SizedBox(),
          error: (_, _) => const SizedBox(),
        ),
        centerTitle: true,
      ),
      body: projectAsync.when(
        data: (project) {
          final logoUrl =
              project.logo ??
              project.coverPhoto ??
              (project.imageUrls.isNotEmpty
                  ? project.imageUrls.first
                  : 'https://picsum.photos/seed/placeholder/200/200'
              );

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover Photo Banner
                      if (project.coverPhoto != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Container(
                            width: double.infinity,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(project.coverPhoto!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      // Header Section (App Store Vibe)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Icon
                          Hero(
                            tag: 'project-image-${project.id}',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(logoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          // Title & Actions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        height: 1.1,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),kjk
                                const SizedBox(height: 8),
                                Text(
                                  project.shortDescription,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppTheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    if (project.downloadLink != null)
                                      _buildGetButton(
                                        context,
                                        label: 'GET',
                                        icon: Icons.cloud_download_rounded,
                                        isPrimary: true,
                                        onPressed: () => launchUrl(
                                          Uri.parse(project.downloadLink!),
                                        ),
                                      ),
                                    if (project.sourceCodeLink != null)
                                      _buildGetButton(
                                        context,
                                        label: 'GITHUB',
                                        icon: Icons.code_rounded,
                                        isPrimary: false,
                                        onPressed: () => launchUrl(
                                          Uri.parse(project.sourceCodeLink!),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),
                      const Divider(color: AppTheme.outlineVariant, height: 1),
                      const SizedBox(height: 48),

                      // Screenshots Gallery
                      if (project.imageUrls.isNotEmpty) ...[
                        Text(
                          'Preview',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: project.imageUrls.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.6, // Phone screenshot ratio
                          ),
                          itemBuilder: (context, index) {
                            final imageUrl = project.imageUrls[index];
                            return GestureDetector(
                              onTap: () => _openImagePreview(context, imageUrl),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerLowWith(context),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppTheme.outlineVariant
                                        .withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22.5),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain, // Prevent cropping
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 48),
                        const Divider(
                          color: AppTheme.outlineVariant,
                          height: 1,
                        ),
                        const SizedBox(height: 48),
                      ],
                      // Description Section
                      Text(
                        'About this app',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        project.fullDescription,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 48),
                      const Divider(color: AppTheme.outlineVariant, height: 1),
                      const SizedBox(height: 48),

                      // Key Features Section
                      Text(
                        'Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...project.features.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppTheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  f,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
        error: (e, s) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  void _openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.9),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                tooltip: 'Download or View Original',
                onPressed: () {
                  launchUrl(Uri.parse(imageUrl));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGetButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppTheme.primary
            : AppTheme.surfaceContainerHighestWith(context),
        foregroundColor: isPrimary
            ? AppTheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ), // Pill shape like App Store
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
