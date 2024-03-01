// import 'dart:typed_data';
import 'package:flutter_show_test/class_lib/set_app_data.dart';
import 'package:get/get.dart';
// import 'class_lib/file_picker_demo.dart';
// import 'class_lib/animated_number_container.dart';
import 'class_lib/preview_img.dart';
// import 'class_lib/image_player.dart';
// import 'class_lib/image_display_page.dart';
import 'package:flutter/material.dart';
import 'class_lib/number_selector.dart';
import 'class_lib/page_result.dart';
// import 'class_lib/socket_picker.dart';
import 'class_lib/logger_service.dart';

void main() async {
  await initServices(); // 初始化Getx
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => LoggerService().init());
  Get.put(SetAppDataController());
  final logger = Get.find<LoggerService>().logger;
  logger.i('init finish');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Show test1',
      theme: ThemeData(
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
  final controller = Get.find<SetAppDataController>();
  // int _index = 0;
  // final int _width = 1024;
  // final int _height = 1000;
  // Uint8List? _receivedImageData;
  // Uint8List? _currentBmpData;
  // Uint8List? _imgin = [];
  // void _numberSelected(int number) {
  //   setState(() {
  //     _index = number;
  //   }); // 这里可以添加更多的逻辑，比如更新startPoint
  // }

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
          // mainAxisAlignment: MainAxisAlignment.left, // 根据需要调整对齐方式
          children: [
            SizedBox(
              width: 35,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => controller.switchPage(1),
                      icon: const Icon(Icons.photo),
                    ),
                    IconButton(
                      onPressed: () => controller.switchPage(0),
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ]),
            ),
            const VerticalDivider(),
            // 这里放置您想要在左侧显示的小部件
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // 例如，一个容器或其他小部件
                children: [
                  const Text("左侧内容"),
                  Obx(() => Text(controller.startPoint.toString())),
                  const DraggableListWheelScrollView(),
                ]),
            const VerticalDivider(),
            const PageSwitch(),
          ]),
    );
  }
}

class PageSwitch extends StatelessWidget {
  const PageSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetAppDataController>();
    return Obx(() {
      switch (controller.showPage.value) {
        case 0:
          return const ImagePreviewWidget();
        case 1:
          return PageResultWidget();
        default:
          return PageResultWidget();
      }
    });
  }
}
