import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for the status bar styling
import 'package:video_player/video_player.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset('assets/splash.mp4')
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });

        _controller.play();

        // Navigate exactly when the video finishes
        Timer(_controller.value.duration, _navigateToHome);
      });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Force the System UI (Status Bar & Nav Bar) to be BLACK
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,          // Top Strip
        statusBarIconBrightness: Brightness.light, // White Battery/Wifi icons
        systemNavigationBarColor: Colors.black, // Bottom Strip
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black, // This fills the empty space

        // 2. The SafeArea adds the "Black Strips" you asked for
        body: SafeArea(
          child: Center(
            child: _initialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(), // Stay black while loading
          ),
        ),
      ),
    );
  }
}