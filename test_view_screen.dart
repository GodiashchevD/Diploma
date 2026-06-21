import 'package:flutter/material.dart';
import '../notes/database_service.dart';

class TestViewScreen extends StatefulWidget {
  final List<dynamic> questions;
  final String title;
  final int? testId;

  const TestViewScreen({
    super.key,
    required this.questions,
    required this.title,
    this.testId,
  });

  @override
  State<TestViewScreen> createState() => _TestViewScreenState();
}

class _TestViewScreenState extends State<TestViewScreen> {
  int currentQuestion = 0;
  late List<int?> answers;

  @override
  void initState() {
    super.initState();
    answers = List.filled(widget.questions.length, null);
  }

  bool allAnswered() => answers.every((a) => a != null);

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (answers[i] == widget.questions[i]['correct']) {
        score++;
      }
    }
    return score;
  }

  Future<void> finishTest() async {
    final score = calculateScore();

    if (widget.testId != null) {
      await DatabaseService.updateTest(
        widget.testId!,
        answers,
        score,
      );
    } else {
      await DatabaseService.insertTest(
        widget.title,
        widget.questions,
        answers,
        score,
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Результат",
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        content: Text(
          "Вы набрали $score из ${widget.questions.length}",
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "ОК",
              style: TextStyle(fontFamily: 'Roboto'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = widget.questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Тест",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
            children: [

              LinearProgressIndicator(
                value: (answers.where((a) => a != null).length) /
                    widget.questions.length,
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2B31)
                      : const Color(0xFFF5F6F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  q["question"] ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ...List.generate(q["answers"].length, (index) {
                final isSelected = answers[currentQuestion] == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      answers[currentQuestion] = index;
                    });

                    if (allAnswered()) {
                      finishTest();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFFA66CFF)
                              : const Color(0xFF7ED7C1))
                          : (isDark
                              ? const Color(0xFF3A3B42)
                              : const Color(0xFFE9ECEF)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      q["answers"][index],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    onPressed: currentQuestion > 0
                        ? () => setState(() => currentQuestion--)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),

                  Text(
                    "${currentQuestion + 1}/${widget.questions.length}",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  IconButton(
                    onPressed:
                        currentQuestion < widget.questions.length - 1
                            ? () => setState(() => currentQuestion++)
                            : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: finishTest,
                child: const Text(
                  "Завершить тест",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}