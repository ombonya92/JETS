import 'package:flutter/material.dart';

import 'package:jets/screens/dashboard_screen.dart';
import 'package:jets/screens/joseph_screen.dart';
import 'package:jets/screens/library_screen.dart';
import 'package:jets/screens/profile_screen.dart';
import 'package:jets/screens/timeline_screen.dart';
import 'package:jets/screens/upload_screen.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key});

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _index = 0;

  void jumpTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(onNavigate: jumpTo),
      const LibraryScreen(),
      const UploadScreen(),
      const TimelineScreen(),
      const JosephScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_file_outlined),
            selectedIcon: Icon(Icons.upload_file),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            selectedIcon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'Joseph',
          ),
        ],
      ),
      // Profile accessible via icon in app bar on dashboard.
      floatingActionButton: _index == 0
          ? FloatingActionButton.small(
              heroTag: 'profile',
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Colors.blue),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            )
          : null,
    );
  }
}