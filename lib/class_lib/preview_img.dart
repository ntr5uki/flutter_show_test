import 'dart:io';
// import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'tcp_client_reciver.dart';

class ImagePreviewWidget extends StatefulWidget {
  const ImagePreviewWidget({super.key});
  @override
  ImagePreviewWidgetState createState() => ImagePreviewWidgetState();
}

class ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  late Socket socket;
  Uint8List? imageBytes;
  late TcpClientRecivier tcpClientHelper;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 400,
      child: RotatedBox(
        quarterTurns: -1,
        child: RepaintBoundary(
          child: imageBytes != null
              ? Image.memory(
                  imageBytes!,
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                )
              : const Center(child: CircularProgressIndicator())
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }
}
