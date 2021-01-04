import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/check_list_widget.dart';
import 'package:todolist/firebase_backend.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO-List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          print('Added a new task');
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController _textEditingController =
                    TextEditingController();
                return AlertDialog(
                  title: Text(
                    'Add New Task',
                    textAlign: TextAlign.center,
                  ),
                  content: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      hintText: 'Add your task here.',
                    ),
                  ),
                  actions: [
                    FlatButton(
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                        child: Text('Add'),
                        onPressed: () async {
                          if (_textEditingController.text.length != 0) {
                            FirebaseBackend _firebaseBackend =
                                FirebaseBackend();
                            await _firebaseBackend
                                .createTodoItem(_textEditingController.text);
                            Navigator.pop(context);
                          }
                        })
                  ],
                );
              });
        },
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
    );
  }

  Container _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore.collection('tasks').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final taskListFromFirebase = snapshot.data.docs;
                  List<CheckListWidget> dataList = [];
                  for (var tasksData in taskListFromFirebase) {
                    var taskDetails = tasksData.data();
                    dataList.add(
                      CheckListWidget(
                        uid: tasksData.id,
                        isDone: taskDetails['isDone'],
                        title: taskDetails["title"],
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return dataList[index];
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 2.0,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
