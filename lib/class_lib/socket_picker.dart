import 'dart:io';
import 'dart:typed_data';
import 'tcp_client_helper.dart';
import 'package:flutter/material.dart';
import 'create_bmp_image.dart';

// import 'package:flutter_image/flutter_image.dart';

class SocketPickerDemo extends StatefulWidget {
  final Function(Map?) onSocketPicked;
  final int width, height;
  const SocketPickerDemo({
    Key? key,
    required this.onSocketPicked,
    required this.width,
    required this.height,
  }) : super(key: key);

  SocketPickerDemoState createState() => SocketPickerDemoState();
}

class SocketPickerDemoState extends State<SocketPickerDemo> {
  // late Socket socket;
  final tcpClientHelper = TcpClientHelper();
  String _status = 'Disconnected';
  List<int> dataBuffer = [];
  // bool isConnected = false;
  Uint8List? receivedData;
  Uint8List? _bmpHead;

  void _connectToServer() async {
    Uint8List bmpHead = await File('assets/dat/bmphead.dat').readAsBytes();
    _bmpHead = createBmpImage(widget.width, widget.height, bmpHead);
    try {
      tcpClientHelper.connect('localhost', 30000);
      setState(() {
        _status = 'Connected';
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _disconnectServer() {
    tcpClientHelper.dispose();
    setState(() {
      _status = 'Disconnected';
    });
  }

  void _listenToData() async {
    try {
      Uint8List fileData = await tcpClientHelper.readAvailableData();
      // Uint8List fileData = data;
      print('fileData:${fileData.length},bmpHead:${_bmpHead?.length}');
      widget.onSocketPicked({"fileData": fileData, "bmpHead": _bmpHead});
      // 处理数据
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Status: $_status'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
                      ),
                    ),
                    onPressed: _connectToServer,
                    child: const Text('Connect to Server'),
                  ),
                ),
              ),
      
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
                      ),
                    ),
                    onPressed: _listenToData,
                    child: const Text('Socket Get'),
                  ),
                ),
              ),
      
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(3), // 这里的10可以根据需要调整为任何数值
                      ),
                    ),
                    onPressed: _disconnectServer,
                    child: const Text('Disconnect'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
