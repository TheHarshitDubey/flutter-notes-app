import 'package:flutter/material.dart';

Future<void> showAddNoteDialog({
  required BuildContext context,
  required Function(String title, String content) onAdd,
}) async {
  String newTitle = '';
  String newContent = '';

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Add Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Title'),
            onChanged: (value) => newTitle = value,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Content'),
            onChanged: (value) => newContent = value,
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
            if (newTitle.isNotEmpty || newContent.isNotEmpty) {
              onAdd(newTitle, newContent);
            }
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
