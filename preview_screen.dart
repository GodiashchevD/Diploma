import 'dart:io';
import 'package:flutter/material.dart';
import '../notes/note_view_screen.dart';
import '../../services/mlkit_ocr_service.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final bool isReturningText;

  const PreviewScreen({
    super.key,
    required this.imagePath,
    this.isReturningText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(File(imagePath)),
              ),
            ),

            const Expanded(child: SizedBox()),

            _gradientButton(
              context: context,
              text: "Распознать текст",
              isDark: isDark,
              onTap: () async {

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const _LoadingDialog(),
                );

                try {
                  final text =
                      await OCRService.recognizeText(File(imagePath));

                  if (!context.mounted) return;

                  Navigator.pop(context); // закрываем лоадер

                  if (isReturningText) {
                    Navigator.pop(context, text);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NoteViewScreen(initialText: text),
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                }
              },
            ),

            const SizedBox(height: 16),

            _secondaryButton(
              context: context,
              text: "Новое фото",
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _gradientButton({
    required BuildContext context,
    required String text,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
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

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),

            const SizedBox(height: 20),

            Text(
              "Распознаём текст...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Это может занять несколько секунд",
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withOpacity(0.6)
                    : Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}