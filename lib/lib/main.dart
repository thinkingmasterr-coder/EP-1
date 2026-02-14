import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'user_data.dart'; // <--- Import UserData

void main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the saved data!
  await UserData.loadData();

  // 3. Run the App
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
      home: const SplashScreen(),
    );
  }
}