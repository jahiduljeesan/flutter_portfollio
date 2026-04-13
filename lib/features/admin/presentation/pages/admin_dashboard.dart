import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../projects/providers/project_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atelier Control Panel', style: TextStyle(color: AppTheme.onSurface)),
        backgroundColor: AppTheme.surfaceContainerLowest,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primary),
            onPressed: () {
              _showProjectDialog(context, ref);
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 250,
            color: AppTheme.surfaceContainerLowest,
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard, color: AppTheme.primary),
                  title: const Text('Projects', style: TextStyle(color: AppTheme.onSurface)),
                  selected: true,
                  selectedTileColor: AppTheme.surfaceContainerHighest.withOpacity(0.4),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.secondary),
                  title: const Text('Logout', style: TextStyle(color: AppTheme.secondary)),
                  onTap: () {
                    // context.go('/');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: projectsAsync.when(
                data: (projects) {
                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return Card(
                        color: AppTheme.surfaceContainerLow,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(project.title, style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text(project.shortDescription, style: const TextStyle(color: AppTheme.secondary)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppTheme.tertiary),
                                onPressed: () {
                                  _showProjectDialog(context, ref, project: project);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  // TODO: Delete project
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showProjectDialog(BuildContext context, WidgetRef ref, {dynamic project}) {
    final isEditing = project != null;
    final titleController = TextEditingController(text: isEditing ? project.title : '');
    final shortDescController = TextEditingController(text: isEditing ? project.shortDescription : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceContainerHighest,
          title: Text(isEditing ? 'Edit Project' : 'Add Project', style: const TextStyle(color: AppTheme.onSurface)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: AppTheme.onSurface),
                  decoration: const InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: AppTheme.secondary)),
                ),
                TextField(
                  controller: shortDescController,
                  style: const TextStyle(color: AppTheme.onSurface),
                  decoration: const InputDecoration(labelText: 'Short Description', labelStyle: TextStyle(color: AppTheme.secondary)),
                ),
                // Additional fields for Full Description, Image URLs, Features, Links would go here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.secondary)),
            ),
            ElevatedButton(
              onPressed: () {
                // Call ref.read(projectRepositoryProvider).addProject/updateProject
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: AppTheme.onPrimary),
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
