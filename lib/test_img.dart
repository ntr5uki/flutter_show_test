import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'class_lib/tcp_client_reciver.dart';

void main() {
  runApp(const ImageDisplayWidget());
}

class ImageDisplayWidget extends StatefulWidget {
  const ImageDisplayWidget({super.key});

  @override
  ImageDisplayWidgetState createState() => ImageDisplayWidgetState();
}

class ImageDisplayWidgetState extends State<ImageDisplayWidget> {
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
    super.initState();
    tcpClientHelper = TcpClientRecivier(
      onDataReceived: _handleDataReceived,
      desiredLength: 1024 * 1000 + 1078,
    );

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
