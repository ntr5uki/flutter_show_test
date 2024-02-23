import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'class_lib/tcp_client_reciver.dart';

void main() {
  runApp(ImageDisplayWidget());
}

class ImageDisplayWidget extends StatefulWidget {
  @override
  _ImageDisplayWidgetState createState() => _ImageDisplayWidgetState();
}

class _ImageDisplayWidgetState extends State<ImageDisplayWidget> {
  late Socket socket;
  Uint8List? imageBytes;
  late TcpClientRecivier tcpClientHelper;
  // final tcpClientHelper = TcpClientRecivier(
  //   onDataReceived: _handleDataReceived,
  //   desiredLength: 1024,
  // ); // 假设您期望的数据长度

  void _handleDataReceived(Uint8List data) {
    setState(() {
      imageBytes = Uint8List.fromList(data);
    });
    // 使用 data 更新图像
  }

  @override
  void initState() {
    tcpClientHelper = TcpClientRecivier(
      onDataReceived: _handleDataReceived,
      desiredLength: 1024 * 1000 + 1078,
    );
    super.initState();
    tcpClientHelper.connect('localhost', 30000);
  }

  // void connectToServer() async {
  //   socket = await Socket.connect('localhost', 30000);
  //   socket.listen((List<int> data) {
  //     setState(() {
  //       imageBytes = Uint8List.fromList(data);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: -1,
        child: RepaintBoundary(
          child: imageBytes != null
              ? Image.memory(
                  imageBytes!,
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                )
              : const CircularProgressIndicator(),
        ),
      );
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }
}
