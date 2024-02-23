import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

class TcpClientHelper {
  RawSocket? _socket;
  final BytesBuilder _dataBuilder = BytesBuilder();
  final Completer<Uint8List> _completer = Completer<Uint8List>();
  late StreamSubscription<RawSocketEvent> _subscription;

  Future<void> connect(String host, int port) async {
    _socket = await RawSocket.connect(host, port);
    _subscription = _socket!.listen(_onData, onDone: _onDone, onError: _onError);    
    
  }

  void _onData(RawSocketEvent event) {
    print('${event}');
    if (event == RawSocketEvent.read) {
      final data = _socket!.read();
      if (data != null) {
        _dataBuilder.add(data);
      }
    }
  }

  void _onDone() {
    print('_onDone');
    _subscription.cancel();
    _completer.complete(_dataBuilder.takeBytes());
  }

  void _onError(error) {
    _subscription.cancel();
    _completer.completeError(error);
  }

  Future<Uint8List> readAvailableData() async {
    Uint8List outdata = _dataBuilder.takeBytes();
    print('outdata length :${outdata.length}');    
    return outdata;
  }

  void dispose() {
    _subscription.cancel();
    _socket?.close();
    _dataBuilder.clear();
  }
}
