// 文件：fetch_data_tcpserver.dart

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class TcpServerHelper {
  Socket? _socket;
  final List<int> _dataBuffer = [];

  Future<void> connectToServer(String host, int port) async {
    _socket = await Socket.connect(host, port);
  }

  StreamSubscription<Uint8List>? listenToData(
    void Function(Uint8List) onData,
    int desiredLength, {
    void Function(Object, StackTrace)? onError,
    void Function()? onDone,
  }) {
    return _socket?.listen(
      (List<int> data) {
        _dataBuffer.addAll(data);
        if (_dataBuffer.length >= desiredLength) {
          // 如果累积的数据达到或超过期望长度
          Uint8List dataChunk =
              Uint8List.fromList(_dataBuffer.take(desiredLength).toList());
          onData(dataChunk); // 调用 onData 回调
          _dataBuffer.removeRange(0, desiredLength); // 从缓冲区中移除已处理的数据
        }
      },
      onError: onError,
      onDone: onDone,
    );
  }

  void dispose() {
    _socket?.destroy();
    _socket = null;
  }

  List<int> get dataBuffer => _dataBuffer;
}
