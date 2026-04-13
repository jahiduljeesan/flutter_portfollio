import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../projects/providers/project_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isDesktop ? null : AppBar(
        title: Text('Atelier Control Panel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.surfaceContainerLowestWith(context),
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: _selectedIndex == 0 ? _buildDashboardView() : _buildProjectsView(),
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 1 ? FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        onPressed: () => _showProjectDialog(context, ref),
        icon: const Icon(Icons.add, color: AppTheme.onPrimary),
        label: const Text('New Project', style: TextStyle(color: AppTheme.onPrimary, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: AppTheme.surfaceContainerLowestWith(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Atelier\nControl Panel',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 16),
          _SidebarItem(
            icon: Icons.dashboard,
            title: 'Overview',
            isSelected: _selectedIndex == 0,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          _SidebarItem(
            icon: Icons.source,
            title: 'Manage Projects',
            isSelected: _selectedIndex == 1,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          const Spacer(),
          const Divider(color: AppTheme.outlineVariant),
          _SidebarItem(
            icon: Icons.logout,
            title: 'Sign Out',
            isSelected: false,
            onTap: () {
              // TODO: Implement logout
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    final projectsAsync = ref.watch(projectsProvider);
    
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good Morning, Architect', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('Here is what is happening with your portfolio today.', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16)),
          const SizedBox(height: 48),
          
          // Metrics Row
          projectsAsync.when(
            data: (projects) {
              int totalViews = projects.fold(0, (sum, item) => sum + item.viewCount);
              return Row(
                children: [
                  Expanded(child: _buildMetricCard('Total Projects', projects.length.toString(), Icons.folder_copy, AppTheme.primary)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildMetricCard('Total Views', totalViews.toString(), Icons.visibility, Colors.purpleAccent)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildMetricCard('Featured', projects.where((p) => p.isFeatured).length.toString(), Icons.star, Colors.amber)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
            error: (e, s) => Text('Error: $e'),
          ),
          
          const SizedBox(height: 48),
          Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 24),
          // Placeholder for recent activity
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowWith(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('No recent activity to show', style: TextStyle(color: AppTheme.outlineVariant)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProjectsView() {
    final projectsAsync = ref.watch(projectsProvider);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manage Projects', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 32),
          Expanded(
            child: projectsAsync.when(
              data: (projects) {
                return ListView.separated(
                  itemCount: projects.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLowWith(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.surfaceContainerHighestWith(context)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(24),
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(project.imageUrls.isNotEmpty ? project.imageUrls.first : 'https://picsum.photos/seed/placeholder/800/600'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(project.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                        subtitle: Text(project.shortDescription, style: TextStyle(color: Theme.of(context).colorScheme.secondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppTheme.primary),
                              tooltip: 'Edit Project',
                              onPressed: () => _showProjectDialog(context, ref, project: project),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: 'Delete Project',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
              error: (e, s) => Text('Error: $e'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowWith(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.surfaceContainer : AppTheme.surfaceContainerHighestWith(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 24),
          Text(value, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  void _showProjectDialog(BuildContext context, WidgetRef ref, {dynamic project}) {
    final isEditing = project != null;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceContainerHighestWith(context),
          title: Text(isEditing ? 'Edit Project' : 'Add New Project', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
               child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Project Title', initialValue: isEditing ? project.title : ''),
                  const SizedBox(height: 16),
                  _buildTextField('Short Description', initialValue: isEditing ? project.shortDescription : '', maxLines: 2),
                  const SizedBox(height: 16),
                  _buildTextField('Full Description', initialValue: isEditing ? project.fullDescription : '', maxLines: 4),
                  const SizedBox(height: 16),
                  _buildTextField('Image URL', initialValue: isEditing && project.imageUrls.isNotEmpty ? project.imageUrls.first : ''),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Source Code URL', initialValue: isEditing ? project.sourceCodeLink : '')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Download URL', initialValue: isEditing ? project.downloadLink : '')),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: AppTheme.onPrimary),
              child: Text(isEditing ? 'Save Changes' : 'Create Project', style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, {String initialValue = '', int maxLines = 1}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppTheme.primary : Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.primary : Theme.of(context).colorScheme.secondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
