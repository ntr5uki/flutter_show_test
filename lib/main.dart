import 'dart:typed_data';
import 'class_lib/file_picker_demo.dart';
import 'class_lib/animated_number_container.dart';
// import 'class_lib/image_player.dart';
import 'class_lib/image_display_page.dart';
import 'package:flutter/material.dart';
import 'class_lib/number_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Show test1',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Show test1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _index = 0;
  final int _width = 1024;
  final int _height = 1000;
  Uint8List? _receivedImageData;
  // Uint8List? _currentBmpData;
  Uint8List? _bmpHead;
  // Uint8List? _imgin = [];

  void _handleFilePicked(Map? data) {
    if (data != null) {
      setState(() {
        _receivedImageData = data['fileData'];
        _bmpHead = data['bmpHead'];
        _counter = _receivedImageData!.length;
      });
    }
  }

  void _numberSelected(int number) {
    setState(() {
      _index = number;
    });
    // 这里可以添加更多的逻辑，比如更新startPoint
  }

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 根据需要调整对齐方式
          children: [
            // 这里放置您想要在左侧显示的小部件
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // 例如，一个容器或其他小部件
                children: [
                  const Text("左侧内容"),
                  Text(_index.toString()),
                  DraggableListWheelScrollView(
                      onNumberSelected: _numberSelected),
                ]),
            const VerticalDivider(),
            Expanded(
              // width: 800,
              // margin: const EdgeInsets.all(5),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '按下后数字增加10:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(221, 211, 13, 13),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: _incrementCounter,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  3), // 这里的10可以根据需要调整为任何数值
                            ),
                          ),
                          child: const Text('Start Incrementing'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: FilePickerDemo(
                          width: _width,
                          height: _height,
                          onFilePicked: _handleFilePicked,
                        ),
                      ),
                      AnimatedNumberContainer(
                        end: _counter,
                      ),
                      ImageDisplayPage(
                        greyImageData: _receivedImageData,
                        width: _width,
                        height: _height,
                        startPoint: _index,
                        bmpHead: _bmpHead,
                        // onDataUpdated: _currentIndexcallback,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
