import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'create_bmp_image.dart';

// import 'package:flutter_image/flutter_image.dart';

class SocketPickerDemo extends StatefulWidget {
  final Function(Map?) onFilePicked;
  final int width, height;
  const SocketPickerDemo({
    Key? key,
    required this.onFilePicked,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  SocketPickerDemoState createState() => SocketPickerDemoState();
}


class SocketPickerDemoState extends State<SocketPickerDemo> {
  Future<void> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List fileData = await file.readAsBytes();
      Uint8List bmpHead = await File('assets/dat/bmphead.dat').readAsBytes();
      bmpHead = createBmpImage(widget.width, widget.height, bmpHead);

      widget.onFilePicked({"fileData": fileData, "bmpHead": bmpHead});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
        ),
      ),
      onPressed: pickAndReadFile,
      child: const Text('Pick File'),
    );
  }
}
