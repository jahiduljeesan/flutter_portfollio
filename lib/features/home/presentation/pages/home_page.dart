import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
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
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Deep space background
      body: Stack(
        children: [
          // Premium Cosmic Background Vibe with Parallax
          Positioned.fill(
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollOffset,
              builder: (context, offset, _) {
                final parallaxOffset = offset * 0.0005; // very subtle
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: const [
                        Color(0xFF1E0B3B), // Deep magenta/purple glow
                        Color(0xFF030A14), // Darker cosmic blue base
                        Color(0xFF000000), // Deep space
                      ],
                      stops: const [0.0, 0.6, 1.0],
                      center: Alignment(-0.8 + parallaxOffset, -0.8 + parallaxOffset),
                      radius: 2.0,
                    ),
                  ),
                );
              },
            ),
          ),
          // Animated Grid/Noise Overlay
          Positioned.fill(
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollOffset,
              builder: (context, offset, _) {
                return Opacity(
                  opacity: 0.04,
                  child: Transform.translate(
                    offset: Offset(0, -offset * 0.1),
                    child: CustomPaint(
                      painter: _GridPainter(),
                    ),
                  ),
                );
              },
            ),
          ),
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
                        'JahidulJeesan',
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
    return Consumer(builder: (context, ref, _) {
      final settings = ref.watch(generalSettingsProvider).value ?? {};
      final title = settings['hero_title'] as String? ?? 'Md. Jahidul Islam';
      final subtitle = settings['hero_subtitle'] as String? ?? 'Flutter Developer';
      final desc = settings['hero_description'] as String? ?? 'Crafting high-impact, pixel-perfect cross-platform experiences with a focus on scalable architecture, fluid animations, and native-level performance.';
      final devImage = settings['dev_image_url'] as String?;
      final displayDevImage = (devImage != null && devImage.isNotEmpty) ? devImage : 'https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg';
      final cvUrl = settings['cv_url'] as String?;

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
                // Text Content
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
                      ).animate().fade().slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 56),
                      ).animate().fade().slideY(begin: 0.2),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryContainer],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          subtitle,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 56,
                          ),
                        ),
                      ).animate(delay: 100.ms).fade().slideY(begin: 0.2),
                      const SizedBox(height: 24),
                      Text(
                        desc,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.secondary,
                          fontSize: 20,
                          height: 1.6,
                        ),
                      ).animate(delay: 200.ms).fade().slideY(begin: 0.2),
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
                                  color: AppTheme.primary.withOpacity(0.4),
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.15),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                )
                              ]
                            ),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.primary, width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                foregroundColor: AppTheme.primary,
                                backgroundColor: AppTheme.primary.withOpacity(0.05),
                              ),
                              onPressed: (cvUrl != null && cvUrl.isNotEmpty) ? () async {
                                await launchUrl(Uri.parse(cvUrl));
                              } : () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CV not available yet.')));
                              },
                              child: const Text('Download CV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ).animate(delay: 400.ms).fade().slideY(begin: 0.2)
                    ],
                  ),
                ),
                if (!isDesktop) const SizedBox(height: 64),
                // Image Content
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
                                color: AppTheme.primary.withOpacity(0.2),
                                blurRadius: 40,
                                spreadRadius: -10,
                                offset: const Offset(0, 20),
                              )
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                child: Image.network(
                                  displayDevImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppTheme.surface.withOpacity(0.9), Colors.transparent],
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
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutQuint).fade(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSkillsSection({Key? key}) {
    const skills = [
      (Icons.terminal, 'Dart'),
      (Icons.flutter_dash, 'Flutter'),
      (Icons.developer_mode, 'Kotlin'),
      (Icons.coffee, 'Java'),
      (Icons.local_fire_department, 'Firebase'),
      (Icons.cloud, 'Google Cloud'),
    ];
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F172A),
            const Color(0xFF1E1B4B).withOpacity(0.6),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ScrollReveal(
                scrollNotifier: _scrollOffset,
                triggerAt: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Toolkit',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800, color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80, height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: skills.asMap().entries.map((e) =>
                  _ScrollReveal(
                    scrollNotifier: _scrollOffset,
                    triggerAt: 700,
                    delay: Duration(milliseconds: e.key * 80),
                    child: _SkillCard(icon: e.value.$1, title: e.value.$2),
                  )
                ).toList(),
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
              _ScrollReveal(
                scrollNotifier: _scrollOffset,
                triggerAt: 1200,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Featured Projects', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 16),
                        Text(
                          'A selection of curated mobile applications focused on fintech, health, and enterprise solutions.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.secondary),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
                      child: const Row(
                        children: [
                          Text('View All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                ],
              )),
              const SizedBox(height: 64),
              // Scroll reveal wrapper handled per-card below
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
                      final card = _ScrollReveal(
                        scrollNotifier: _scrollOffset,
                        triggerAt: 1350,
                        delay: Duration(milliseconds: i * 100),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: _ProjectCard(project: projects[i]),
                        ),
                      );
                      if (i % 2 == 0) leftCol.add(card);
                      else rightCol.add(card);
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
                      children: projects.asMap().entries.map((e) =>
                        _ScrollReveal(
                          scrollNotifier: _scrollOffset,
                          triggerAt: 600,
                          delay: Duration(milliseconds: e.key * 100),
                          child: Padding(padding: const EdgeInsets.only(bottom: 48), child: _ProjectCard(project: e.value)),
                        )
                      ).toList(),
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
    return Consumer(builder: (context, ref, _) {
      final settings = ref.watch(generalSettingsProvider).value ?? {};
      final githubUrl = settings['github_url'] as String? ?? 'https://github.com/jahiduljeesan';
      final linkedinUrl = settings['linkedin_url'] as String? ?? 'https://linkedin.com/in/jahiduljeesan';
      final emailUrl = settings['email_url'] as String? ?? 'mailto:hello@example.com';

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
                  '©All right reserved by Md Jahidul Islam.',
                  style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 0.5),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SocialIcon(
                      assetPath: 'assets/icons/github_logo.png',
                      onTap: () => launchUrl(Uri.parse(githubUrl)),
                    ),
                    const SizedBox(width: 16),
                    _SocialIcon(
                      assetPath: 'assets/icons/linkedin_logo.png',
                      onTap: () => launchUrl(Uri.parse(linkedinUrl)),
                    ),
                    const SizedBox(width: 16),
                    _SocialIcon(
                      assetPath: 'assets/icons/email_logo.png',
                      onTap: () => launchUrl(Uri.parse(emailUrl)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
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

class _SkillCard extends StatefulWidget {
  final IconData icon;
  final String title;

  const _SkillCard({required this.icon, required this.title});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuint,
        width: 180,
        padding: const EdgeInsets.all(32),
        transform: _isHovered ? (Matrix4.identity()..translate(0, -8, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.primary.withOpacity(0.05) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppTheme.primary.withOpacity(0.5) : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: -5,
              )
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _isHovered ? AppTheme.primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, color: _isHovered ? AppTheme.primary : Colors.white70, size: 28),
            ),
            const SizedBox(height: 20),
            Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
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
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuint,
        width: 500,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -12, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppTheme.primary.withOpacity(0.3) : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.6 : 0.3),
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
                    child: Consumer(builder: (context, ref, _) {
                      final settings = ref.watch(generalSettingsProvider).value ?? {};
                      final placeholderUrl = settings['placeholder_image_url'] as String? ?? 'https://picsum.photos/seed/placeholder/800/600';
                      return Image.network(
                        project.coverPhoto != null && project.coverPhoto!.isNotEmpty 
                            ? project.coverPhoto! 
                            : (project.imageUrls.isNotEmpty ? project.imageUrls.first : placeholderUrl),
                        fit: BoxFit.cover,
                      );
                    }),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SocialIcon extends StatefulWidget {
  final String assetPath;
  final VoidCallback onTap;
  const _SocialIcon({required this.assetPath, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered ? (Matrix4.identity()..scale(1.15)) : Matrix4.identity(),
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: _isHovered ? [
              BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 16, spreadRadius: -2)
            ] : [],
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(widget.assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// A widget that animates into view when the scroll offset passes [triggerAt].
class _ScrollReveal extends StatelessWidget {
  final ValueNotifier<double> scrollNotifier;
  final double triggerAt;
  final Widget child;
  final Duration delay;

  const _ScrollReveal({
    required this.scrollNotifier,
    required this.triggerAt,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollNotifier,
      builder: (context, scrollOffset, _) {
        final bool hasRevealed = scrollOffset >= triggerAt;
        
        return AnimatedOpacity(
          opacity: hasRevealed ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: hasRevealed ? Offset.zero : const Offset(0, 0.08),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            child: child,
          ),
        );
      },
    );
  }
}

