import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      backgroundColor: const Color(0xFF020617),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A).withOpacity(0.7),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: projectAsync.maybeWhen(
          data: (project) => Text(
            project.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          orElse: () => const SizedBox(),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Premium background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF020617)],
                  center: Alignment.topRight,
                  radius: 1.5,
                ),
              ),
            ),
          ),
          // Grid overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
          // Content
          projectAsync.when(
            data: (project) {
              final logoUrl = project.logo ??
                  project.coverPhoto ??
                  (project.imageUrls.isNotEmpty
                      ? project.imageUrls.first
                      : 'https://picsum.photos/seed/placeholder/200/200');

              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cover Banner
                          if (project.coverPhoto != null)
                            Container(
                              width: double.infinity,
                              height: 320,
                              margin: const EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.15),
                                    blurRadius: 40,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(project.coverPhoto!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ).animate().fade(duration: 600.ms).slideY(begin: 0.1),

                          // Header Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'project-image-${project.id}',
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppTheme.primary.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(logoUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 28),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      project.shortDescription,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: [
                                        if (project.downloadLink != null)
                                          _ActionButton(
                                            label: 'Download',
                                            icon: Icons.cloud_download_rounded,
                                            isPrimary: true,
                                            onPressed: () => launchUrl(Uri.parse(project.downloadLink!)),
                                          ),
                                        if (project.sourceCodeLink != null)
                                          _ActionButton(
                                            label: 'GitHub',
                                            icon: Icons.code_rounded,
                                            isPrimary: false,
                                            onPressed: () => launchUrl(Uri.parse(project.sourceCodeLink!)),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).animate(delay: 100.ms).fade(duration: 600.ms).slideY(begin: 0.1),

                          const SizedBox(height: 48),
                          _Divider(),
                          const SizedBox(height: 48),

                          // Screenshots
                          if (project.imageUrls.isNotEmpty) ...[
                            _SectionTitle(title: 'Preview'),
                            const SizedBox(height: 24),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: project.imageUrls.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.6,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => _openImagePreview(context, project.imageUrls[index]),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D1F29),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.primary.withOpacity(0.15),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18.5),
                                      child: Image.network(
                                        project.imageUrls[index],
                                        fit: BoxFit.contain,
                                        loadingBuilder: (c, child, p) =>
                                            p == null ? child : const Center(child: CircularProgressIndicator()),
                                      ),
                                    ),
                                  ),
                                ).animate(delay: (index * 80).ms).fade().slideY(begin: 0.15);
                              },
                            ),
                            const SizedBox(height: 48),
                            _Divider(),
                            const SizedBox(height: 48),
                          ],

                          // About
                          _SectionTitle(title: 'About this app'),
                          const SizedBox(height: 20),
                          Text(
                            project.fullDescription,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 16,
                              height: 1.7,
                            ),
                          ).animate(delay: 200.ms).fade().slideY(begin: 0.1),

                          const SizedBox(height: 48),
                          _Divider(),
                          const SizedBox(height: 48),

                          // Features
                          _SectionTitle(title: 'Features'),
                          const SizedBox(height: 24),
                          ...project.features.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: AppTheme.primary, size: 13),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    e.value,
                                    style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                                  ),
                                ),
                              ],
                            ).animate(delay: (e.key * 60 + 300).ms).fade().slideX(begin: -0.05),
                          )),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
            error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
          ),
        ],
      ),
    );
  }

  void _openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
              onPressed: () => launchUrl(Uri.parse(imageUrl)),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppTheme.primary.withOpacity(0.15));
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;
  const _ActionButton({required this.label, required this.icon, required this.isPrimary, required this.onPressed});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_hovered ? AppTheme.primary : AppTheme.primary.withOpacity(0.85))
                : (_hovered ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.06)),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isPrimary ? Colors.transparent : AppTheme.primary.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: widget.isPrimary ? AppTheme.onPrimary : AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: widget.isPrimary ? AppTheme.onPrimary : Colors.white,
                ),
              ),
            ],
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
