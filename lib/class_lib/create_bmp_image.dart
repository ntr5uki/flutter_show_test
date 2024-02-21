import 'dart:typed_data';

Uint8List createBmpImage(int width, int height, Uint8List bmpHead) {
  // 使用必要的修改更新bmpHead
  bmpHead = dataSwitch(bmpHead, 2, width * height + 1078);
  bmpHead = dataSwitch(bmpHead, 18, width);
  bmpHead = dataSwitch(bmpHead, 22, height);
  bmpHead = dataSwitch(bmpHead, 34, width * height);
  // 从dataImg中截取特定区域的数据
  return Uint8List.fromList(bmpHead);
}

Uint8List dataSwitch(Uint8List bmpHead, int start, int intIn) {
  var bytes = ByteData.sublistView(bmpHead);
  bytes.setUint32(start, intIn, Endian.little);
  return bytes.buffer.asUint8List();
}
