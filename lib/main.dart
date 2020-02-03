import 'package:flutter/material.dart';

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
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("TODO List"),
      ),
      body: Container(
        child: Center(
          child: Text("Hello World"),
        ),
      ),
    );
  }
}
