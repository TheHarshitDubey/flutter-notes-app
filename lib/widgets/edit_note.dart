import 'package:flutter/material.dart';

Future<void> showEditNoteDialog({
  required BuildContext context,
  required String initialTitle,
  required String initialContent,
  required Function(String title, String content) onSave,
}) async {
  final titleController = TextEditingController(text: initialTitle);
  final contentController = TextEditingController(text: initialContent);

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(labelText: 'Content'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(titleController.text, contentController.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
