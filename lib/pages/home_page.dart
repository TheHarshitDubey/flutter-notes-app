import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/theme/theme_notifier.dart';
import 'package:provider/provider.dart';
import '../firebase/firestore_service.dart';

class HomePage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
      icon: Icon(Icons.brightness_6),
      onPressed: () {
        Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
      },
    ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!.docs;

          if (notes.isEmpty) {
            return const Center(child: Text("No notes yet"));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              return Card(
                child: ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => firestoreService.deleteNote(note.id),
                  ),
                  onTap: () {
                    _showNoteDialog(
                      context,
                      initialTitle: note['title'],
                      initialContent: note['content'],
                      noteId: note.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context,
      {String? initialTitle, String? initialContent, String? noteId}) {
    final titleController = TextEditingController(text: initialTitle ?? '');
    final contentController = TextEditingController(text: initialContent ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(noteId == null ? "Add Note" : "Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Content"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteId == null) {
                  firestoreService.addNote(
                    titleController.text,
                    contentController.text,
                  );
                } else {
                  firestoreService.updateNote(
                    noteId,
                    titleController.text,
                    contentController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
