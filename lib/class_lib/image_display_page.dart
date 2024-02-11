// import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'dart:async';
import 'dart:typed_data';
// import 'package:image/image.dart' as img;

class ImageDisplayPage extends StatelessWidget {
  final Uint8List? greyImageData;
  final Uint8List? currentBmpData;
  final int width, height;
  final int startPoint;
  final Function(Uint8List?) onDataUpdated; // 回调函数

  const ImageDisplayPage({
    Key? key,
    required this.greyImageData,
    required this.width,
    required this.height,
    required this.currentBmpData,
    required this.onDataUpdated,
    this.startPoint = 0, // 设置默认值为0
  }) : super(key: key);

  Uint8List createBmpImage(int width, int height, int startPoint,
      Uint8List bmpHead, Uint8List dataImg) {
    // 使用必要的修改更新bmpHead
    bmpHead = dataSwitch(bmpHead, 2, width * height + 1078);
    bmpHead = dataSwitch(bmpHead, 18, width);
    bmpHead = dataSwitch(bmpHead, 22, height);
    bmpHead = dataSwitch(bmpHead, 34, width * height);
    int startIdx = startPoint * width * height;

    // 从dataImg中截取特定区域的数据
    Uint8List imgDataSection =
        dataImg.sublist(startIdx, startIdx + width * height);

    // 将bmpHead和截取的imgDataSection拼接
    return Uint8List.fromList(bmpHead + imgDataSection);
  }

  Uint8List dataSwitch(Uint8List bmpHead, int start, int intIn) {
    var bytes = ByteData.sublistView(bmpHead);
    bytes.setUint32(start, intIn, Endian.little);
    return bytes.buffer.asUint8List();
  }

  Future<Uint8List> createBmpImageAsync(int width, int height, int startPoint,
      Uint8List bmpHead, Uint8List dataImg) async {
    return createBmpImage(width, height, startPoint, bmpHead, dataImg);
  }

  Future<Uint8List> loadBmpHead() async {
    // 从assets加载bmpHead.dat文件
    // var bmpHead = await File('bmphead.dat').readAsBytes();
    return await File('assets/dat/bmphead.dat').readAsBytes();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Uint8List>(
  //     future: loadBmpHead(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           snapshot.hasData) {
  //         // 数据加载完成，可以使用snapshot.data
  //         Uint8List bmpHead = snapshot.data!;
  //         // 进行更多操作...
  //         return Text("BMP Head Loaded"); // 示例：显示加载完成
  //       } else if (snapshot.hasError) {
  //         return Text("Error: ${snapshot.error}");
  //       } else {
  //         // 数据正在加载，显示加载指示器
  //         return CircularProgressIndicator();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (greyImageData == null || greyImageData!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    Uint8List? bmpDatanow = currentBmpData;
    return RotatedBox(
      quarterTurns: -1,
      child: SizedBox(
        width: 400,
        height: 600,
        child: FutureBuilder<Uint8List>(
          future: loadBmpHead(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Uint8List bmpHead = snapshot.data!;

              return FutureBuilder<Uint8List>(
                future: createBmpImageAsync(
                    width, height, startPoint, bmpHead, greyImageData!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    bmpDatanow = snapshot.data; // 更新当前图像数据
                    onDataUpdated(bmpDatanow);
                    return Image.memory(
                      bmpDatanow!,
                      gaplessPlayback: true,
                      fit: BoxFit.fill,
                    );
                  } else {
                    // 如果新图像数据还在处理中，继续显示当前图像
                    return currentBmpData != null
                        ? Image.memory(
                            bmpDatanow!,
                            gaplessPlayback: true,
                            fit: BoxFit.fill,
                          )
                        : Container(); // 如果没有当前图像，则显示一个空容器或其他占位符
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error loading bmp head: ${snapshot.error}");
            } else {
              return currentBmpData != null
                  ? Image.memory(
                      currentBmpData!,
                      gaplessPlayback: true,
                      fit: BoxFit.fill,
                    )
                  : const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
