import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../projects/providers/project_provider.dart';
import '../../../projects/models/project.dart';

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
        onPressed: () {
          showDialog(
            context: context, 
            builder: (_) => const _ProjectFormDialog(),
          );
        },
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
    
    return SingleChildScrollView(
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
          Text('Global Settings', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 24),
          const _GeneralSettingsCard(),
          const SizedBox(height: 24),
          const _AdminCredentialsCard(),
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
                if (projects.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No project available', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  ));
                }

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
                              onPressed: () {
                                showDialog(
                                  context: context, 
                                  builder: (_) => _ProjectFormDialog(project: project),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: 'Delete Project',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Project?'),
                                    content: const Text('Are you sure you want to completely erase this project?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
                                    ]
                                  )
                                );
                                if (confirm == true) {
                                  await ref.read(projectRepositoryProvider).deleteProject(project.id);
                                  ref.invalidate(projectsProvider);
                                }
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

// Replaced static dialog with Stateful Dialog
}

class _ProjectFormDialog extends ConsumerStatefulWidget {
  final Project? project;
  const _ProjectFormDialog({this.project});

  @override
  ConsumerState<_ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends ConsumerState<_ProjectFormDialog> {
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _fullDescController = TextEditingController();
  final _imageController = TextEditingController();
  final _coverPhotoController = TextEditingController();
  final _logoController = TextEditingController();
  final _sourceController = TextEditingController();
  final _downloadController = TextEditingController();
  final _featuresController = TextEditingController();
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.title;
      _shortDescController.text = widget.project!.shortDescription;
      _fullDescController.text = widget.project!.fullDescription;
      _imageController.text = widget.project!.imageUrls.join(', ');
      _coverPhotoController.text = widget.project!.coverPhoto ?? '';
      _logoController.text = widget.project!.logo ?? '';
      _sourceController.text = widget.project!.sourceCodeLink ?? '';
      _downloadController.text = widget.project!.downloadLink ?? '';
      _featuresController.text = widget.project!.features.join(', ');
      _isFeatured = widget.project!.isFeatured;
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final isEditing = widget.project != null;
    final proj = Project(
      id: isEditing ? widget.project!.id : '',
      title: _titleController.text.trim(),
      shortDescription: _shortDescController.text.trim(),
      fullDescription: _fullDescController.text.trim(),
      features: _featuresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      imageUrls: _imageController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      coverPhoto: _coverPhotoController.text.trim().isNotEmpty ? _coverPhotoController.text.trim() : null,
      logo: _logoController.text.trim().isNotEmpty ? _logoController.text.trim() : null,
      sourceCodeLink: _sourceController.text.trim().isNotEmpty ? _sourceController.text.trim() : null,
      downloadLink: _downloadController.text.trim().isNotEmpty ? _downloadController.text.trim() : null,
      isFeatured: _isFeatured,
      viewCount: isEditing ? widget.project!.viewCount : 0,
    );

    try {
      if (isEditing) {
        await ref.read(projectRepositoryProvider).updateProject(proj);
      } else {
        await ref.read(projectRepositoryProvider).addProject(proj);
      }
      ref.invalidate(projectsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.outlineVariant), borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.project != null;
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
              _buildTextField('Project Title', _titleController),
              const SizedBox(height: 16),
              _buildTextField('Short Description', _shortDescController, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Full Description', _fullDescController, maxLines: 4),
              const SizedBox(height: 16),
              _buildTextField('Features (comma separated)', _featuresController, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Screenshots URLs (comma separated)', _imageController, maxLines: 2),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Cover Photo URL', _coverPhotoController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Logo URL', _logoController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Source Code URL', _sourceController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Download URL', _downloadController)),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Featured Project'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
                activeThumbColor: AppTheme.primary,
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: AppTheme.onPrimary),
          child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(isEditing ? 'Save Changes' : 'Create Project', style: const TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}

class _GeneralSettingsCard extends StatefulWidget {
  const _GeneralSettingsCard();

  @override
  State<_GeneralSettingsCard> createState() => _GeneralSettingsCardState();
}

class _GeneralSettingsCardState extends State<_GeneralSettingsCard> {
  final TextEditingController _cvController = TextEditingController();
  final TextEditingController _devImageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final doc = await FirebaseFirestore.instance.collection('settings').doc('general').get();
    if (doc.exists) {
      if (doc.data()!.containsKey('cv_url')) {
        _cvController.text = doc.data()!['cv_url'];
      }
      if (doc.data()!.containsKey('dev_image_url')) {
        _devImageController.text = doc.data()!['dev_image_url'];
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('settings').doc('general').set(
        {
          'cv_url': _cvController.text.trim(),
          'dev_image_url': _devImageController.text.trim(),
        }, 
        SetOptions(merge: true)
      );
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Global Settings Updated.')));
      }
    } catch (e) {
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firebase Error: $e'), backgroundColor: Colors.redAccent));
      }
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowWith(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Global Configurations', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('Manage public links such as your Curriculum Vitae and developer profile picture.', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cvController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'CV URL',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _devImageController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Developer Image URL',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveSettings,
                icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
              )
            ],
          )
        ],
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

class _AdminCredentialsCard extends StatefulWidget {
  const _AdminCredentialsCard();

  @override
  State<_AdminCredentialsCard> createState() => _AdminCredentialsCardState();
}

class _AdminCredentialsCardState extends State<_AdminCredentialsCard> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('settings').doc('admin').get();
      if (doc.exists) {
        _userController.text = doc.data()?['username'] ?? '';
        _passController.text = doc.data()?['password'] ?? '';
      }
    } catch (e) {
      debugPrint("Could not load credentials: $e");
    }
  }

  Future<void> _saveCredentials() async {
    if (_userController.text.trim().isEmpty || _passController.text.trim().isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('settings').doc('admin').set(
        {
          'username': _userController.text.trim(),
          'password': _passController.text.trim()
        }, 
        SetOptions(merge: true)
      );
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin Credentials Updated.')));
      }
    } catch (e) {
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firebase Error: $e'), backgroundColor: Colors.redAccent));
      }
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowWith(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin Credentials', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text('Update your dashboard login credentials. Default is jahiduljeesan.', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _userController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _passController,
                  obscureText: true,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveCredentials,
                icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.security),
                label: const Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
