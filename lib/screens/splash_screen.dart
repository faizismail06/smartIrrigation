import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_irrigation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi plant growing
            Container(
              height: 200,
              width: 200,
              margin: const EdgeInsets.only(bottom: 30),
              child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_lujpxicq.json',
                controller: _animationController,
                fit: BoxFit.contain,
              ),
            ),

            // Title
            Text(
              'SMART IRRIGATION',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Sistem Irigasi Otomatis DRY/WET',
              style: TextStyle(
                color: colorScheme.onBackground.withOpacity(0.7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            // Loading indicator
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  backgroundColor: colorScheme.surfaceVariant,
                  color: colorScheme.primary,
                  minHeight: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
