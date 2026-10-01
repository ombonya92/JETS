import 'package:flutter/material.dart';
import 'screens/main/main_screens.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const JETSApp());
}

class JETSApp extends StatelessWidget {
  const JETSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JETS',
      theme: AppTheme.lightTheme,
      home: const MainScreens(),
    );
  }
}