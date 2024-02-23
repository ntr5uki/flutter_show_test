import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

typedef DataReceivedCallback = void Function(Uint8List data);

class TcpClientRecivier {
  RawSocket? _socket;
  final BytesBuilder _dataBuilder = BytesBuilder();
  late StreamSubscription<RawSocketEvent> _subscription;
  final DataReceivedCallback onDataReceived;
  final int desiredLength;

  TcpClientRecivier(
      {required this.onDataReceived, required this.desiredLength});

  Future<void> connect(String host, int port) async {
    _socket = await RawSocket.connect(host, port);
    _subscription =
        _socket!.listen(_onData, onDone: _onDone, onError: _onError);
  }

  void _onData(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final data = _socket!.read();
      if (data != null) {
        _dataBuilder.add(data);
        while (_dataBuilder.length >= desiredLength) {
          // 获取前 desiredLength 个字节
          Uint8List fullData = _dataBuilder.takeBytes();
          Uint8List imageData =
              Uint8List.sublistView(fullData, 0, desiredLength);

          // 调用回调函数处理 imageData
          onDataReceived(imageData);
          print('$imageData[1],$imageData[2],$imageData[3]');

          // 移除已处理的数据
          int remainingLength = _dataBuilder.length - desiredLength;

          // 清除 dataBuilder 并添加剩余的数据
          if (remainingLength > 0) {
            Uint8List remainingData = Uint8List.sublistView(
              fullData,
              desiredLength,
              fullData.length,
            );
            _dataBuilder.add(remainingData);
          }
        }
      }
    }
  }

  void _onDone() {
    _subscription.cancel();
    if (_dataBuilder.length > 0) {
      onDataReceived(_dataBuilder.takeBytes());
    }
  }

  void _onError(error) {
    _subscription.cancel();
    // 可以选择在发生错误时调用回调函数或者处理错误
  }

  void dispose() {
    _subscription.cancel();
    _socket?.close();
    _dataBuilder.clear();
  }
}
