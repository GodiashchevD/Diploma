import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../main_screen.dart';
import 'note_view_screen.dart';
import 'database_service.dart';

class NotesScreen extends StatefulWidget {
  final bool isSelecting;

  const NotesScreen({
    super.key,
    this.isSelecting = false,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await DatabaseService.getNotes();
    setState(() => notes = data);
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
                    widget.isSelecting
                        ? "Выберите конспект"
                        : "Ваши конспекты",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: notes.isEmpty
                        ? const Center(child: Text("Нет конспектов"))
                        : ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];

                              return _noteCard(
                                title: note['title'] ?? "",
                                subtitle: note['text'] ?? "",
                                date: note['date'] ?? "",
                                isDark: isDark,

                                onTap: () async {
                                  if (widget.isSelecting) {
                                    Navigator.pop(context, note);
                                  } else {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => NoteViewScreen(
                                          initialText: note['text'],
                                          initialTitle: note['title'],
                                          noteId: note['id'],
                                        ),
                                      ),
                                    );
                                    loadNotes();
                                  }
                                },

                                onDelete: () async {
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Удалить конспект?"),
                                      content: const Text(
                                          "Вы уверены, что хотите удалить этот конспект?"),
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
                                    await DatabaseService.deleteNote(note['id']);
                                    loadNotes();
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            if (!widget.isSelecting)
              CustomBottomBar(
                currentIndex: 1,
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

  Widget _noteCard({
    required String title,
    required String subtitle,
    required String date,
    required bool isDark,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? const Color(0xFF3A3B42)
                    : const Color(0xFFF0F2F5),
              ),
              child: const Icon(Icons.menu_book),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isEmpty ? "Без названия" : title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    date.isNotEmpty
                        ? date.toString().substring(0, 16)
                        : "",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}