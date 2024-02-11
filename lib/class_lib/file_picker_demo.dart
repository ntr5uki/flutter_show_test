import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_image/flutter_image.dart';

class FilePickerDemo extends StatefulWidget {
  final Function(Uint8List)? onFilePicked;

  const FilePickerDemo({Key? key, this.onFilePicked}) : super(key: key);

  @override
  FilePickerDemoState createState() => FilePickerDemoState();
}

class FilePickerDemoState extends State<FilePickerDemo> {
  Future<void> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List fileData = await file.readAsBytes();
      if (widget.onFilePicked != null) {
        widget.onFilePicked!(fileData);
      }
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
/*   Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
            BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
          ),
        ),
      onPressed: pickAndReadFile,
      child: Text('Pick File'),
    );
  } */
}
