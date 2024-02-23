import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  const width = 1024;
  const height = 1000;

  // 读取bmphead.dat
  var bmpHead = await File('./bmphead.dat').readAsBytes();

  // 读取octa2.dat
  var dataImg = await File('octa2.dat').readAsBytes();

  // 使用必要的修改更新bmpHead
  bmpHead = dataSwitch(bmpHead, 2, dataImg.length + 1078);
  bmpHead = dataSwitch(bmpHead, 18, width);
  bmpHead = dataSwitch(bmpHead, 22, height);
  bmpHead = dataSwitch(bmpHead, 34, width * height);

  // 可选：写入到新文件
  var file = File('test.bmp');
  var sink = file.openWrite();
  sink.add(bmpHead);
  sink.add(dataImg);
  await sink.close();
}

Uint8List dataSwitch(Uint8List bmpHead, int start, int intIn) {
  var bytes = ByteData.sublistView(bmpHead);
  bytes.setUint32(start, intIn, Endian.little);
  return bytes.buffer.asUint8List();
}
