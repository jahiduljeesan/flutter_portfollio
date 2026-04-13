import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();
    if (user.isEmpty || pass.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final doc = await FirebaseFirestore.instance.collection('settings').doc('admin').get();
      bool isAuthenticated = false;

      if (doc.exists && doc.data()!.containsKey('username') && doc.data()!.containsKey('password')) {
        final dbUser = doc.data()!['username'];
        final dbPass = doc.data()!['password'];
        if (user == dbUser && pass == dbPass) {
          isAuthenticated = true;
        }
      } else {
        // Fallback default provision
        if (user == 'jahiduljeesan' && pass == 'jahiduljeesan') {
          isAuthenticated = true;
          // Silently provision the doc
          await FirebaseFirestore.instance.collection('settings').doc('admin').set({
            'username': 'jahiduljeesan',
            'password': 'jahiduljeesan'
          });
        }
      }

      if (isAuthenticated) {
        if (mounted) context.go('/admin');
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials'), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connection Error: $e'), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Access', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text('Sign in to manage projects.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondary)),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: AppTheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: AppTheme.secondary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppTheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppTheme.secondary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2)) 
                          : const Text('Authenticate', style: TextStyle(color: AppTheme.onPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
