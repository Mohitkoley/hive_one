import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_one/boxes.dart';
import 'package:hive_one/model/todo.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO LISTS"),
        centerTitle: true,
      ),
      body: Container(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>(HiveBoxes.todo).listenable(),
          builder: (context, Box<Todo> box, _) {
            if (box.values.isEmpty) {
              return Center(child: const Text("There is no value"));
            }
            return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  Todo? res = box.getAt(index);
                  return Dismissible(
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      res!.delete();
                    },
                    key: UniqueKey(),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      textColor: Colors.blueAccent,
                      title: Text(res!.title),
                      subtitle: Text(res.description),
                    ),
                  );
                });
          },
        ),
        padding: EdgeInsets.all(8.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTodoScreen()))
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: "Add Todo",
      ),
    );
  }
}
