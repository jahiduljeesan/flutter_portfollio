import 'dart:ui';
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
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      backgroundColor: AppTheme.surfaceContainerLowestWith(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => context.go('/'),
            ),
          ),
        ),
      ),
      body: projectAsync.when(
        data: (project) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Image
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Hero(
                      tag: 'project-image-${project.id}',
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              project.coverPhoto ?? (project.imageUrls.isNotEmpty ? project.imageUrls.first : 'https://picsum.photos/seed/placeholder/800/600'),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                AppTheme.surfaceContainerLowestWith(context).withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Main Content Card
                Transform.translate(
                  offset: const Offset(0, -60),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      elevation: 40,
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      color: AppTheme.surfaceContainerWith(context),
                      child: Padding(
                        padding: EdgeInsets.all(isDesktop ? 64 : 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Action Buttons (Moved under cover photo in the card)
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                if (project.downloadLink != null)
                                  _buildActionButton(
                                    context,
                                    label: 'Download App',
                                    icon: Icons.download_rounded,
                                    isPrimary: true,
                                    onPressed: () => launchUrl(Uri.parse(project.downloadLink!)),
                                  ),
                                if (project.sourceCodeLink != null)
                                  _buildActionButton(
                                    context,
                                    label: 'Source Code',
                                    icon: Icons.code_rounded,
                                    isPrimary: false,
                                    onPressed: () => launchUrl(Uri.parse(project.sourceCodeLink!)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 48),

                            Text(
                              project.title,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              project.fullDescription,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.secondary,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            // Key Features Section
                            Text(
                              'Key Features',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildFeaturesList(context, project.features),
                            
                            const SizedBox(height: 48),
                            
                            // Screenshots Gallery (New Section)
                            if (project.imageUrls.isNotEmpty) ...[
                              Text(
                                'Gallery',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 400,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: project.imageUrls.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        project.imageUrls[index],
                                        fit: BoxFit.cover,
                                        width: 280,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary ? const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        borderRadius: BorderRadius.circular(16),
        border: !isPrimary ? Border.all(color: AppTheme.outlineVariant) : null,
        boxShadow: isPrimary ? [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: isPrimary ? AppTheme.onPrimary : Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context, List<String> features) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: features.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHighestWith(context).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: AppTheme.primary, size: 20),
            const SizedBox(width: 12),
            Text(f, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      )).toList(),
    );
  }
}
