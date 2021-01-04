import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseBackend {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  createTodoItem(String title) async {
    try {
      await _firebaseFirestore.collection("tasks").add({
        'title': title,
        'isDone': false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateTodoItem(bool isDone, String uid) async {
    try {
      await _firebaseFirestore.collection("tasks").doc(uid).update({
        'isDone': isDone,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  deleteTodoItem(String uid) async {
    try {
      await _firebaseFirestore.collection("tasks").doc(uid).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
