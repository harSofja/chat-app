import 'package:chat_app/widgets/screens/intro/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (_isFirstLaunch) {
      _controller.forward();
    }

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()));
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // Reset the flag for testing purposes
    await prefs.setBool('first_launch', true);
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (_isFirstLaunch) {
      await prefs.setBool('first_launch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isFirstLaunch
            ? FadeTransition(
                opacity: _animation,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child:
                      Image.asset('assets/images/chat_logo.png'), // Your logo
                ),
              )
            : SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/chat_logo.png'), // Your logo
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
