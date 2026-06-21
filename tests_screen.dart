import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../main_screen.dart';
import '../notes/notes_screen.dart';
import 'test_view_screen.dart';
import 'test_service.dart';
import '../notes/database_service.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  int currentIndex = 2;
  List<Map<String, dynamic>> tests = [];

  @override
  void initState() {
    super.initState();
    loadTests();
  }

  Future<void> loadTests() async {
    final data = await DatabaseService.getTests();
    setState(() => tests = data);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Тесты",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: tests.isEmpty
                        ? Center(child: _createButton(isDark))
                        : ListView.builder(
                            itemCount: tests.length + 1,
                            itemBuilder: (context, index) {

                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _createButton(isDark),
                                );
                              }

                              final test = tests[index - 1];
                              final questions = jsonDecode(test['questions']);

                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TestViewScreen(
                                        questions: questions,
                                        title: test['title'] ?? "Тест",
                                        testId: test['id'],
                                      ),
                                    ),
                                  );
                                  loadTests();
                                },

                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2A2B31)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Row(
                                    children: [

                                      const Icon(Icons.quiz),
                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              test['title'] ?? "Новый тест",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Roboto',
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              "${test['score'] ?? 0}/${questions.length}",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              test['date']
                                                      ?.toString()
                                                      .substring(0, 16) ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Roboto',
                                                color: isDark
                                                    ? Colors.white54
                                                    : Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      IconButton(
                                        icon: const Icon(Icons.help_outline),
                                        onPressed: () {},
                                      ),

                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text("Удалить тест?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, false),
                                                  child: const Text("Отмена"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, true),
                                                  child: const Text("Удалить"),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            await DatabaseService.deleteTest(
                                                test['id']);
                                            loadTests();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            CustomBottomBar(
              currentIndex: currentIndex,
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
      ),
    );
  }

  Widget _createButton(bool isDark) {
    return GestureDetector(
      onTap: () async {
        final note = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotesScreen(isSelecting: true),
          ),
        );

        if (note == null) return;

        showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2A2B31)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: isDark
                  ? const Color(0xFFA66CFF)
                  : const Color(0xFF6FA8DC),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Создаем тест",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Cоставляем вопросы",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  ),
);

        final questions =
            await TestService.generateTest(note['text']);

        Navigator.pop(context);

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TestViewScreen(
              questions: questions,
              title: note['title'] ?? "Новый тест",
            ),
          ),
        );

        loadTests();
      },

      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
        child: const Text(
          "Составить тест",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}