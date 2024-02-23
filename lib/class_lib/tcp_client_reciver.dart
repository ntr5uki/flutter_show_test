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

  TcpClientRecivier({required this.onDataReceived, required this.desiredLength});

  Future<void> connect(String host, int port) async {
    _socket = await RawSocket.connect(host, port);
    _subscription = _socket!.listen(_onData, onDone: _onDone, onError: _onError);
  }

  void _onData(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final data = _socket!.read();
      if (data != null) {
        _dataBuilder.add(data);
        if (_dataBuilder.length >= desiredLength) {
          // 调用回调函数
          onDataReceived(_dataBuilder.takeBytes());
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
