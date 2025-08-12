import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get userNotesCollection =>
      _firestore.collection('users').doc(userId).collection('notes');

  Future<void> addNote(String title, String content) {
    return userNotesCollection.add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotes() {
    return userNotesCollection.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String id, String title, String content) {
    return userNotesCollection.doc(id).update({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) {
    return userNotesCollection.doc(id).delete();
  }
}
