import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = isDark
        ? const Color(0xFFA66CFF)
        : const Color(0xFF59BFA8);

    final inactiveColor = isDark
        ? const Color(0xFF7A7A85)
        : const Color(0xFF9AA0A6);

    return Positioned(
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

            _item(Icons.camera_alt, "Сканирование", 0, activeColor, inactiveColor),
            _item(Icons.menu_book, "Конспекты", 1, activeColor, inactiveColor),
            _item(Icons.quiz, "Тесты", 2, activeColor, inactiveColor),
            _item(Icons.settings, "Настройки", 3, activeColor, inactiveColor),

          ],
        ),
      ),
    );
  }

  Widget _item(
  IconData icon,
  String label,
  int index,
  Color active,
  Color inactive,
) {
  final isSelected = currentIndex == index;

  return Expanded( //исп. для равномерного распределения элементов навигационной панели 
    child: GestureDetector(
      behavior: HitTestBehavior.opaque, //вся область кнопки становится кликабельной
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? active : inactive),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? active : inactive,
            ),
          ),
        ],
      ),
    ),
  );
}
}
