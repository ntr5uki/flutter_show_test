import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'create_bmp_image.dart';
import '../state/set_app_data.dart';
import 'package:get/get.dart';
// import 'package:flutter_image/flutter_image.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({Key? key}) : super(key: key);

  @override
  FilePickerDemoState createState() => FilePickerDemoState();
}

// Uint8List createBmpImage(int width, int height, Uint8List bmpHead) {
//   // 使用必要的修改更新bmpHead
//   bmpHead = dataSwitch(bmpHead, 2, width * height + 1078);
//   bmpHead = dataSwitch(bmpHead, 18, width);
//   bmpHead = dataSwitch(bmpHead, 22, height);
//   bmpHead = dataSwitch(bmpHead, 34, width * height);
//   // 从dataImg中截取特定区域的数据
//   return Uint8List.fromList(bmpHead);
// }

// Uint8List dataSwitch(Uint8List bmpHead, int start, int intIn) {
//   var bytes = ByteData.sublistView(bmpHead);
//   bytes.setUint32(start, intIn, Endian.little);
//   return bytes.buffer.asUint8List();
// }

class FilePickerDemoState extends State<FilePickerDemo> {
  Future<void> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      //使用getx获取参数
      final controller = Get.find<SetAppDataController>();
      int width = controller.octWidth.value;
      int height = controller.octHeight.value;
      File file = File(result.files.single.path!);
      Uint8List fileData = await file.readAsBytes();
      Uint8List bmpHead = await File('assets/dat/bmphead.dat').readAsBytes();
      bmpHead = createBmpImage(width, height, bmpHead);
      //更新getx中的参数
      controller.startPoint.value = 0;
      controller.receivedImageData.value = fileData;
      controller.bmpHead.value = bmpHead;     
      controller.tempIndex.value = fileData.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3), 
            ),
          ),
          onPressed: pickAndReadFile,
          child: const Text('Pick File'),
        ),
      ),
    );
  }
}
