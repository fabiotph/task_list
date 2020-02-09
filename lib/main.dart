import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_list/models/task.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      darkTheme:
          ThemeData(primaryColor: Colors.amber, brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
    );
  }
}

class HomePage extends StatefulWidget {
  var tasks = new List<Task>();

  HomePage() {
    tasks = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = new TextEditingController();
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  _HomePageState() {
    loadTasks();
  }

  void addTask() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.tasks.add(
        Task(title: newTaskCtrl.text, done: false),
      );
      newTaskCtrl.clear();
    });
    saveTasks();
  }

  void removeTask(int index) {
    List<Task> listTask = new List<Task>.from(widget.tasks);
    setState(() {
      widget.tasks.removeAt(index);
    });
    final snackBar = new SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text("Tarefa Excluída"),
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          setState(() {
            print(widget.tasks);
            widget.tasks = listTask;
            print(widget.tasks);
          });
          saveTasks();
        },
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
    saveTasks();
  }

  loadTasks() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Task> result = decoded.map((elem) => Task.fromJson(elem)).toList();
      setState(() {
        widget.tasks = result;
      });
    }
  }

  saveTasks() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.tasks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          autocorrect: true,
          autovalidate: true,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
          ),
          decoration: InputDecoration(
            labelText: "Criar nova tarefa",
            labelStyle: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.tasks.length,
          itemBuilder: (BuildContext ctx, int index) {
            final task = widget.tasks[index];
            return Dismissible(
              child: CheckboxListTile(
                  title: Text(task.title),
                  value: task.done,
                  activeColor: Colors.amber,
                  subtitle: Text(task.subtitle),
                  onChanged: (value) {
                    setState(() {
                      task.done = value;
                    });
                    saveTasks();
                  }),
              key: Key(task.id.toString()),
              background: Container(
                color: Colors.red.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.delete), Text("Excluir")],
                ),
              ),
              onDismissed: (direction) {
                removeTask(index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
