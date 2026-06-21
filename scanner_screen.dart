import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'preview_screen.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../main_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final bool isReturningText;

  const HomeScreen({
    super.key,
    this.isReturningText = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> openCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(
          isReturningText: widget.isReturningText,
        ),
      ),
    );

    if (result == null) return;

    if (widget.isReturningText) {
      Navigator.pop(context, result);
      return;
    }

    if (result is String) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            imagePath: result,
            isReturningText: false,
          ),
        ),
      );
    }
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;


    if (widget.isReturningText) {
      Navigator.pop(context, picked.path);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(
          imagePath: picked.path,
          isReturningText: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Загрузите фото\nучебного материала",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFC9C6FF)
                          : const Color(0xFF2B2B2B),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDark
                          ? const LinearGradient(
                              colors: [Color(0xFF6A5AE0), Color(0xFFF6B26B)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF7ED7C1), Color(0xFF6FA8DC)],
                            ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _gradientButton(
                    context: context,
                    text: "Сделать фото",
                    onTap: openCamera,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  _secondaryButton(
                    context: context,
                    text: "Выбрать из галереи",
                    onTap: pickFromGallery,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          CustomBottomBar(
            currentIndex: 0,
            onTap: (index) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(initialIndex: index),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _gradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFFA66CFF)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF7ED7C1), Color(0xFF6FA8DC)],
                ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF2A2B31)
              : const Color(0xFFE9ECEF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDark
                  ? const Color(0xFFD6D6D6)
                  : const Color(0xFF3A86FF),
            ),
          ),
        ),
      ),
    );
  }
}