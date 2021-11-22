import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import '../constants_for_identification.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userToDo = '';
  List todoList = [];
  List listID = [];

  set snapshot(snapshot) {}

  void initFirebase() async {
    FirebaseAuth.initialize(apiKey, VolatileStore());
    Firestore.initialize(projectId);
    var auth = FirebaseAuth.instance;
    await auth.signIn(email, password);
    var ref = Firestore.instance.collection('test');
    ref.stream.listen((document) async {
      var doc = await ref.get();
      todoList.clear();
      listID.clear();
      for (var i = 0; i < doc.length; i++) {
        listID.add(doc[i].id);
        setState(() {
          todoList.add(doc[i].map["item"]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Список справ'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(todoList[index]),
              child: Card(
                child: ListTile(
                  title: Text(todoList[index]),
                  trailing: IconButton(
                    onPressed: () {
                      Firestore.instance
                          .collection('test')
                          .document(listID[index])
                          .delete();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              onDismissed: (direction) {
                Firestore.instance
                    .collection('test')
                    .document(listID[index])
                    .delete();
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Додати нагадування'),
                  content: TextField(
                    onChanged: (String value) {
                      _userToDo = value;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          if (_userToDo != '') {
                            Firestore.instance
                                .collection('test')
                                .add({'item': _userToDo});
                            Navigator.of(context).pop();
                          }
                          _userToDo = '';
                        },
                        child: const Text('Додати'))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add_box,
          color: Colors.grey,
        ),
      ),
    );
  }
}
