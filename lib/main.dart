import 'package:flutter/material.dart';

import 'core/app_controller.dart';
import 'screens/main/main_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppController.instance.init();
  runApp(const JetsApp());
}

class JetsApp extends StatelessWidget {
  const JetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JETS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreens(),
    );
  }
}