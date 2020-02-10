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
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final listKey = new GlobalKey<AnimatedListState>();

  _HomePageState() {
    loadTasks();
  }

  void getNewTask() {
    if (newTaskCtrl.text.isEmpty) return;
    Task newTask = new Task(title: newTaskCtrl.text, done: false);
    newTaskCtrl.clear();
    addTask(newTask);
  }

  void addTask(Task task) {
    print(task.title);
    int index = widget.tasks.length;
    setState(() {
      widget.tasks.add(task);
    });
    listKey.currentState
        .insertItem(index, duration: Duration(milliseconds: 1000));
    saveTasks();
  }

  void removeTask(int index) {
    List<Task> listTask = new List<Task>.from(widget.tasks);
    Task task;
    setState(() {
      task = widget.tasks.removeAt(index);
    });

    listKey.currentState.removeItem(index,
        (BuildContext context, Animation animation) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
        child: SizeTransition(
          sizeFactor:
              CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
          axisAlignment: 0.0,
          child: _buildItem(task),
        ),
      );
    }, duration: Duration(milliseconds: 0));

    final snackBar = new SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text("Tarefa Excluída"),
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          setState(() {
            widget.tasks = listTask;
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
      decoded.forEach((elem) => {addTask(Task.fromJson(elem))});
      // setState(() {
      //   widget.tasks = result;
      // });
    }
  }

  saveTasks() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.tasks));
  }

  Widget _buildItem(Task task, [int index]) {
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
      body: AnimatedList(
          key: listKey,
          initialItemCount: widget.tasks.length,
          itemBuilder: (BuildContext ctx, int index, Animation animation) {
            final task = widget.tasks[index];
            return FadeTransition(
              opacity: animation,
              child: _buildItem(task, index),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: getNewTask,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
