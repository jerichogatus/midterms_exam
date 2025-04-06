import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulated loading delay

    final user = ref.read(authProvider);

    // Use the `mounted` property of the `State` class
    if (!mounted) return;

    if (user != null) {
      // Navigate based on user role
      Navigator.pushReplacementNamed(context, user.role == 'admin' ? '/admin_home' : '/user_home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100), // Placeholder for your app logo
            const SizedBox(height: 16),
            const Text('Loading...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const CircularProgressIndicator(), // Visual loading indicator
          ],
        ),
      ),
    );
  }
}