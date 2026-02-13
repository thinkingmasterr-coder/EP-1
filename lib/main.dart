import 'package:flutter/material.dart';
import 'splash_screen.dart'; // <--- IMPORT THIS

void main() {
  runApp(const EasypaisaApp());
}

class EasypaisaApp extends StatelessWidget {
  const EasypaisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easypaisa Clone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(), // <--- CHANGE THIS LINE
    );
  }
}