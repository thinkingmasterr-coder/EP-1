import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <--- Added
import 'splash_screen.dart';
import 'user_data.dart';

void main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(); // <--- Added

  // 3. Load the saved data!
  await UserData.loadData();

  // 4. Run the App
  runApp(const EasypaisaApp());
}

class EasypaisaApp extends StatelessWidget {
  const EasypaisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easypaisa',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
