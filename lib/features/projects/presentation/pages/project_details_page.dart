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
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => context.go('/'),
        ),
      ),
      body: projectAsync.when(
        data: (project) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (project.coverPhoto != null || project.imageUrls.isNotEmpty)
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Image.network(
                      project.coverPhoto ?? project.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title, style: Theme.of(context).textTheme.displayMedium),
                      const SizedBox(height: 24),
                      Text(
                        project.fullDescription,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 40),
                      Text('Key Features', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      ...project.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppTheme.tertiary, size: 24),
                            const SizedBox(width: 16),
                            Expanded(child: Text(f, style: Theme.of(context).textTheme.bodyLarge)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          if (project.sourceCodeLink != null)
                            ElevatedButton.icon(
                              onPressed: () => launchUrl(Uri.parse(project.sourceCodeLink!)),
                              icon: const Icon(Icons.code),
                              label: const Text('Source Code'),
                            ),
                          if (project.downloadLink != null)
                            ElevatedButton.icon(
                              onPressed: () => launchUrl(Uri.parse(project.downloadLink!)),
                              icon: const Icon(Icons.download),
                              label: const Text('Download App'),
                            ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
