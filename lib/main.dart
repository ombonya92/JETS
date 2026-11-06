import 'package:flutter/material.dart';

import 'core/app_controller.dart';
import 'screens/main/main_screens.dart';
import 'screens/welcome_screen.dart';
import 'state/auth_state.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.lightTheme,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.resumed) {
      AppController.instance.authState.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppController.instance.authState,
      builder: (context, _) {
        final status = AppController.instance.authState.status;

        if (status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (status == AuthStatus.authenticated) {
          return const MainScreens();
        }

        return const WelcomeScreen();
      },
    );
  }
}