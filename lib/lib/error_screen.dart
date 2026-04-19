import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => const ErrorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 300,
              height: 350,
              child: Stack(
                children: [
                  // 1. THE IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Transform.scale(
                      scale: 1.02,
                      child: Image.asset(
                        'assets/error.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 2. THE CLOSE BUTTON (Invisible hit area)
                  Positioned(
                    top: 6,
                    right: 5,
                    width: 30,
                    height: 30,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: Colors.transparent, // Made invisible
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
