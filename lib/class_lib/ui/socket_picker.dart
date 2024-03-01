import 'dart:io';
import 'dart:typed_data';
import '../socket/tcp_client_helper.dart';
import 'package:flutter/material.dart';
import 'create_bmp_image.dart';
import 'package:get/get.dart';
import '../state/logger_service.dart';
import '../set_app_data.dart';

// import 'package:flutter_image/flutter_image.dart';

class SocketPickerDemo extends StatefulWidget {
  const SocketPickerDemo({Key? key}) : super(key: key);

  @override
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
    final controller = Get.find<SetAppDataController>();
    _bmpHead = createBmpImage(
      controller.octWidth.value,
      controller.octHeight.value,
      bmpHead,
    );
    try {
      await tcpClientHelper.connect('localhost', 30000);
      setState(() {
        _status = 'Connected';
      });
    } catch (e) {
      final logger = Get.find<LoggerService>().logger;
      // 如果连接失败，记录错误信息到Logger
      logger.e('无法连接: $e');
      Get.defaultDialog(
        title: "错误",
        content: Text('连接失败: $e'),
        textCancel: "确认",
      );

      // Get.snackbar('错误', '连接失败: $e');
      // 还可以根据需要做其他处理，比如重新尝试连接或通知用户
    }
  }

  void _disconnectServer() {
    try {
      tcpClientHelper.dispose();
    } catch (e) {
      final logger = Get.find<LoggerService>().logger;
      logger.e('dispose fail');
      Get.snackbar('错误', '断开失败: $e');
    }
    setState(() {
      _status = 'Disconnected';
    });
  }

  void _listenToData() async {
    try {
      Uint8List fileData = await tcpClientHelper.readAvailableData();
      // Uint8List fileData = data;
      final logger = Get.find<LoggerService>().logger;
      final controller = Get.find<SetAppDataController>();
      controller.bmpHead.value = _bmpHead;
      controller.receivedImageData.value = fileData;
      controller.tempIndex.value = fileData.length;
      logger.i('fileData:${fileData.length},bmpHead:${_bmpHead?.length}');
      Get.snackbar(
        '提示',
        'fileData:${fileData.length},bmpHead:${_bmpHead?.length}',
      );
    } catch (e) {
      final logger = Get.find<LoggerService>().logger;
      logger.e('错误: $e');
      Get.snackbar('错误', '$e');
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

  @override
  void dispose() {
    final logger = Get.find<LoggerService>().logger;
    try {
      tcpClientHelper.dispose();
      logger.i('Socket Closed');
    } catch (e) {
      logger.e('dispose fail:$e');
    }

    super.dispose();
  }
}
