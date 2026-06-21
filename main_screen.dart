import 'package:flutter/material.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/tests/tests_screen.dart';
import '../screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late int currentIndex;

  final screens = const [
    HomeScreen(),
    NotesScreen(),
    TestsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return screens[currentIndex];
  }
}