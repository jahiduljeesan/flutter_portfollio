import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../projects/providers/project_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80), // Padding for nav bar
                _buildHeroSection(key: _homeKey),
                _buildSkillsSection(key: _skillsKey),
                _buildProjectsSection(key: _projectsKey),
                _buildFooter(),
              ],
            ),
          ),
          
          // Fixed Top NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  color: const Color(0xFF0F172A).withOpacity(0.6), // slate-900/60
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jahidul.dev',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      
                      // Desktop Nav Links
                      if (MediaQuery.of(context).size.width > 768)
                        Row(
                          children: [
                            _NavBarTextButton(
                              text: 'Home',
                              isActive: true,
                              onTap: () => _scrollToKey(_homeKey),
                            ),
                            const SizedBox(width: 32),
                            _NavBarTextButton(
                              text: 'Skills',
                              onTap: () => _scrollToKey(_skillsKey),
                            ),
                            const SizedBox(width: 32),
                            _NavBarTextButton(
                              text: 'Projects',
                              onTap: () => _scrollToKey(_projectsKey),
                            ),
                          ],
                        ),
                      
                      // Action Icons
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: AppTheme.primary),
                            onPressed: () {
                              ref.read(themeModeProvider.notifier).toggle();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.admin_panel_settings, color: AppTheme.primary),
                            onPressed: () {
                              context.push('/login');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection({Key? key}) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    return Container(
      key: key,
      constraints: const BoxConstraints(minHeight: 800),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text Content (Left on Desktop, Bottom on Mobile)
              Expanded(
                flex: isDesktop ? 6 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ARCHITECTURE & PERFORMANCE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Md. Jahidul Islam',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 56),
                    ),
                     ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryContainer],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        'Flutter Developer',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 56,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Crafting high-impact, pixel-perfect cross-platform experiences with a focus on scalable architecture, fluid animations, and native-level performance.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondary,
                        fontSize: 20,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.primaryContainer],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ]
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _showContactDialog(context),
                            child: const Text('Contact Me', style: TextStyle(color: AppTheme.onPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Consumer(
                          builder: (context, ref, child) {
                            final cvAsync = ref.watch(cvProvider);
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.outlineVariant),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: cvAsync.isLoading ? null : () async {
                                final url = cvAsync.value;
                                if (url != null && url.isNotEmpty) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('CV not available yet.')),
                                  );
                                }
                              },
                              child: cvAsync.isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Download CV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            );
                          }
                        )
                      ],
                    )
                  ],
                ),
              ),
              if (!isDesktop) const SizedBox(height: 64),
              // Image Content (Right on Desktop, Top on Mobile physically, but structurally order is reversed in HTML to put image on top on mobile using classes)
              // Wait, in Stitch it says order-1 for image on mobile. We will just render it below text for simplicity unless specified.
              Expanded(
                flex: isDesktop ? 5 : 0,
                child: Align(
                  alignment: isDesktop ? Alignment.centerRight : Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: isDesktop ? 450 : 300,
                        height: isDesktop ? 550 : 380,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.surfaceContainerWith(context),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            )
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Consumer(builder: (context, ref, child) {
                              final devImageAsync = ref.watch(devImageProvider);
                              final imageUrl = devImageAsync.when(
                                data: (url) => (url != null && url.isNotEmpty) ? url : 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=600&auto=format&fit=crop',
                                loading: () => 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=600&auto=format&fit=crop',
                                error: (_, __) => 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=600&auto=format&fit=crop',
                              );
                              return ColorFiltered(
                                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.surface.withOpacity(0.8), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -24,
                        left: -24,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1+',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'YEARS EXPERIENCE',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.onPrimaryContainer.withOpacity(0.8),
                                  letterSpacing: 2.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsSection({Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      color: AppTheme.surfaceContainerLowWith(context),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Toolkit',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Container(width: 80, height: 4, color: AppTheme.primary),
              const SizedBox(height: 64),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _SkillCard(icon: Icons.terminal, title: 'Dart'),
                  _SkillCard(icon: Icons.flutter_dash, title: 'Flutter'),
                  _SkillCard(icon: Icons.developer_mode, title: 'Kotlin'),
                  _SkillCard(icon: Icons.coffee, title: 'Java'),
                  _SkillCard(icon: Icons.local_fire_department, title: 'Firebase'),
                  _SkillCard(icon: Icons.cloud, title: 'Google Cloud'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection({Key? key}) {
    final projectsAsync = ref.watch(projectsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Featured Projects', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        Text(
                          'A selection of curated mobile applications focused on fintech, health, and enterprise solutions.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.secondary),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
                          child: const Row(
                            children: [
                              Text('View All Archives', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        )
                      ],
                    )
                ],
              ),
              const SizedBox(height: 64),
              projectsAsync.when(
                data: (projects) {
                  if (projects.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('No projects available at the moment', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  }
                  if (isDesktop) {
                    final leftCol = <Widget>[];
                    final rightCol = <Widget>[];
                    for (int i = 0; i < projects.length; i++) {
                      if (i % 2 == 0) {
                        leftCol.add(Padding(padding: const EdgeInsets.only(bottom: 64), child: _ProjectCard(project: projects[i])));
                      } else {
                        rightCol.add(Padding(padding: const EdgeInsets.only(bottom: 64), child: _ProjectCard(project: projects[i])));
                      }
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(children: leftCol)),
                        const SizedBox(width: 48),
                        Expanded(child: Padding(padding: const EdgeInsets.only(top: 120), child: Column(children: rightCol))),
                      ],
                    );
                  } else {
                    return Column(
                      children: projects.map((p) => Padding(padding: const EdgeInsets.only(bottom: 48), child: _ProjectCard(project: p))).toList(),
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                error: (err, stack) => Text('Error loading projects: $err', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      decoration: BoxDecoration(
        color: const Color(0xFF020617), // slate-950
        border: Border(top: BorderSide(color: Colors.blueGrey.withOpacity(0.2))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 24,
            spacing: 24,
            children: [
              const Text(
                '© 2024 The Digital Architect. Designed with intentional asymmetry.',
                style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 0.5),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: (){}, child: const Text('GITHUB', style: TextStyle(color: Colors.grey))),
                  TextButton(onPressed: (){}, child: const Text('LINKEDIN', style: TextStyle(color: Colors.grey))),
                  TextButton(onPressed: (){}, child: const Text('EMAIL', style: TextStyle(color: Colors.grey))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void _showContactDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHighestWith(context),
        title: Text('Start a Conversation', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.outlineVariant), borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLowestWith(context),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 5,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Your Message',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.outlineVariant), borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLowestWith(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final subject = Uri.encodeComponent(subjectController.text);
              final body = Uri.encodeComponent(messageController.text);
              final Uri emailLaunchUri = Uri.parse('mailto:hello@example.com?subject=$subject&body=$body');
              await launchUrl(emailLaunchUri);
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary, 
              foregroundColor: AppTheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      )
    );
  }

}

class _NavBarTextButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarTextButton({required this.text, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: isActive ? const Border(bottom: BorderSide(color: AppTheme.primary, width: 2)) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? AppTheme.primary : AppTheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SkillCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerWith(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHighestWith(context),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final dynamic project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 500,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -12, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerWith(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.2),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            SizedBox(
              height: 400,
              child: Stack(
                fit: StackFit.expand,
                children: [
                   Hero(
                    tag: 'project-image-${project.id}',
                    child: Image.network(
                      project.coverPhoto != null && project.coverPhoto!.isNotEmpty 
                          ? project.coverPhoto! 
                          : (project.imageUrls.isNotEmpty ? project.imageUrls.first : 'https://picsum.photos/seed/placeholder/800/600'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient Overlay for readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  // Tags overlaid on image
                  Positioned(
                    top: 24,
                    left: 24,
                    child: Row(
                      children: [
                        _buildTag('NATIVE', Colors.white.withOpacity(0.2)),
                        const SizedBox(width: 8),
                        _buildTag('FLUTTER', AppTheme.primary.withOpacity(0.8), isPrimary: true),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            // Details Container
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    project.shortDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondary,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push('/project/${project.id}');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          padding: EdgeInsets.zero,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('View Project', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: _isHovered ? (Matrix4.identity()..translate(4, 0, 0)) : Matrix4.identity(),
                              child: const Icon(Icons.arrow_forward_rounded, size: 20),
                            ),
                          ],
                        ),
                      ),
                      // Optional: View Count or Date
                      Text(
                        '${project.viewCount} views',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.secondary.withOpacity(0.5)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color, {bool isPrimary = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? AppTheme.onPrimary : Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
