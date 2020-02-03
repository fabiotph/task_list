import 'package:flutter/material.dart';
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
    tasks.add(Task(title: "Tarefa 1", done: false));
    tasks.add(Task(title: "Tarefa 2", done: true));
    tasks.add(Task(title: "Tarefa 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("TODO List"),
      ),
      body: ListView.builder(
          itemCount: widget.tasks.length,
          itemBuilder: (BuildContext ctx, int index) {
            final task = widget.tasks[index];
            return CheckboxListTile(
                title: Text(task.title),
                key: Key(task.id.toString()),
                value: task.done,
                onChanged: null,
                activeColor: Colors.amber,
                subtitle: Text(task.subtitle));
          }),
    );
  }
}
