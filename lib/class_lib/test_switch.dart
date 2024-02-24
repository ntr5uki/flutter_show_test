import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter switch test ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _currentWidget = WidgetA(); // 默认显示 WidgetA

  void _switchWidget() {
    setState(() {
      if (_currentWidget is WidgetA) {
        _currentWidget = WidgetB();
      } else {
        _currentWidget = WidgetA();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Switch Example'),
      ),
      body: Center(
        child: _currentWidget,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchWidget,
        tooltip: 'Switch',
        child: Icon(Icons.swap_horiz),
      ),
    );
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Widget A');
  }
}

class WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Widget B');
  }
}
