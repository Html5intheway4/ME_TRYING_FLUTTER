import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'result_screen.dart';

void main() {
  runApp(SkinCancerDetectionApp());
}

class SkinCancerDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // '/results': (context) => ResultsScreen(ModalRoute.of(context)?.settings.arguments as String),
        '/results': (context) => ResultsScreen([]), // Pass an empty list initially

      },
    );
  }
}
