import 'package:flutter/material.dart';
import 'package:todolist/firebase_backend.dart';

class CheckListWidget extends StatefulWidget {
  final String uid;
  final String title;
  final bool isDone;

  CheckListWidget({
    @required this.uid,
    @required this.title,
    @required this.isDone,
  });

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  @required
  bool value;
  void initState() {
    value = widget.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          onLongPress: () async {
            FirebaseBackend _firebaseBackend = FirebaseBackend();
            await _firebaseBackend.deleteTodoItem(widget.uid);
          },
          title: Text(
            widget.title,
            style: TextStyle(
              decoration:
                  value ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            onChanged: (bool value) async {
              FirebaseBackend _firebaseBackend = FirebaseBackend();
              await _firebaseBackend.updateTodoItem(value, widget.uid);
              setState(() {
                this.value = value;
              });
            },
            value: value,
          ),
        ),
      ),
    );
  }
}
