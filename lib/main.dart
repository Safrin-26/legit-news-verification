import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LegitApp());
}

class LegitApp extends StatelessWidget {
  const LegitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
