// import 'dart:typed_data';
import 'package:get/get.dart';
import 'file_picker_demo.dart';
import 'animated_number_container.dart';
import 'image_display_page.dart';
import 'package:flutter/material.dart';
import 'socket_picker.dart';
import '../state/set_app_data.dart';

class PageResultWidget extends StatelessWidget {
  // Uint8List? _receivedImageData;
  final controller = Get.find<SetAppDataController>();
  PageResultWidget({super.key});
  void _incrementCounter() => controller.tempIndex = controller.tempIndex + 10;
  // Uint8List? _bmpHead;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      // width: 800,
      child: ListView(
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)), // 20像素的垂直间隔

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: _incrementCounter,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
                          ),
                        ),
                        child: const Text('Start Incrementing'),
                      ),
                    ),
                  ),
                  const FilePickerDemo(),
                ],
              ),
              const SocketPickerDemo(),
              Obx(
                () => AnimatedNumberContainer(
                  end: controller.tempIndex.value,
                ),
              ),
              // const ImagePreviewWidget(),
              ImageDisplayPage(),
            ],
          ),
        ],
      ),
    );
  }
}
