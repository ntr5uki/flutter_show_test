import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../state/logger_service.dart';

void main() async {
  await initServices(); // 初始化Logger
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => LoggerService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    final logger = Get.find<LoggerService>().logger;
    logger.i("HomeScreen built");
    return const GetMaterialApp(
      title: 'Dispose Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool showCustomWidget = true;

  void toggleWidget() {
    setState(() {
      showCustomWidget = !showCustomWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispose Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (showCustomWidget) const CustomWidget(),
            ElevatedButton(
              onPressed: toggleWidget,
              child: const Text('Toggle Widget'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({super.key});

  @override
  CustomWidgetState createState() => CustomWidgetState();
}

class CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    final logger = Get.find<LoggerService>().logger;
    logger.i('Hello, World!');
    return const Text('Hello, World!');
  }

  @override
  void dispose() {
    final logger = Get.find<LoggerService>().logger;
    logger.i("CustomWidget disposed");
    // print('CustomWidget disposed');
    super.dispose();
  }
}
