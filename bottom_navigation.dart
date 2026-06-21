import 'package:flutter/material.dart';

import '../features/scanner/scanner_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/tests/tests_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const NotesScreen(),
    const TestsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [

          // 📱 ЭКРАН
          _screens[_currentIndex],

          // 🔥 КАСТОМНЫЙ BOTTOM BAR
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF202127)
                    : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _buildItem(Icons.camera_alt, "Сканирование", 0),
                  _buildItem(Icons.menu_book, "Конспекты", 1),
                  _buildItem(Icons.quiz, "Тесты", 2),
                  _buildItem(Icons.settings, "Настройки", 3),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, int index) {

    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = isDark
        ? const Color(0xFFA66CFF)
        : const Color(0xFF59BFA8);

    final inactiveColor = isDark
        ? const Color(0xFF7A7A85)
        : const Color(0xFF9AA0A6);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: isSelected ? activeColor : inactiveColor,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),

        ],
      ),
    );
  }
}