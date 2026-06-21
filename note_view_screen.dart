import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../main_screen.dart';
import 'database_service.dart';
import '../scanner/scanner_screen.dart';

class NoteViewScreen extends StatefulWidget {
  final String? initialText;
  final String? initialTitle;
  final int? noteId;

  const NoteViewScreen({
    super.key,
    this.initialText,
    this.initialTitle,
    this.noteId,
  });

  @override
  State<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController textController;
  late TextEditingController titleController;

  int currentIndex = 1;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(
      text: widget.initialText ?? "",
    );

    titleController = TextEditingController(
      text: widget.initialTitle ?? "",
    );
  }

  Future<void> saveNote() async {
    final text = textController.text;
    final title = titleController.text;

    if (widget.noteId != null) {
      await DatabaseService.updateNote(widget.noteId!, title, text);
    } else {
      await DatabaseService.insertNote(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          style: const TextStyle(fontFamily: 'Roboto'),
          decoration: const InputDecoration(
            hintText: "Название",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveNote,
          )
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          onPressed: () async {
            final newText = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const HomeScreen(isReturningText: true),
              ),
            );

            if (!mounted) return;

            if (newText != null &&
                newText is String &&
                newText.isNotEmpty) {
              textController.text =
                  "${textController.text.trim()}\n\n$newText";
            }
          },
          child: const Icon(Icons.add),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 85),
              child: TextField(
                controller: textController,
                maxLines: null,
                expands: true,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
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
}