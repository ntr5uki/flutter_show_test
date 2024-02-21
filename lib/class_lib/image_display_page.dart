// import 'dart:math';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'dart:async';
import 'dart:typed_data';
// import 'package:image/image.dart' as img;

class ImageDisplayPage extends StatelessWidget {
  final Uint8List? greyImageData;
  final Uint8List? bmpHead;
  final int width, height;
  final int startPoint;
  // final Function(Uint8List?) onDataUpdated; // 回调函数

  const ImageDisplayPage({
    Key? key,
    required this.greyImageData,
    required this.width,
    required this.height,
    required this.bmpHead,
    // required this.onDataUpdated,
    this.startPoint = 0, // 设置默认值为0
  }) : super(key: key);

  Uint8List createBmpImage(int width, int height, int startPoint,
      Uint8List bmpHead, Uint8List dataImg) {
    int startIdx = startPoint * width * height;
    // 从dataImg中截取特定区域的数据
    Uint8List imgDataSection =
        dataImg.sublist(startIdx, startIdx + width * height);
    // 创建一个足够大的Uint8List来容纳两个列表
    Uint8List outData = Uint8List(
      bmpHead.length + imgDataSection.length,
    );
    // 将bmpHead复制到新列表的开始部分
    outData.setRange(0, bmpHead.length, bmpHead);
    // 将imgDataSection复制到紧接着bmpHead之后的部分
    outData.setRange(
      bmpHead.length,
      bmpHead.length + imgDataSection.length,
      imgDataSection,
    );

    // 将bmpHead和截取的imgDataSection拼接
    return outData;
  }

  @override
  Widget build(BuildContext context) {
    if (greyImageData == null || greyImageData!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    Uint8List bmpDatanow = createBmpImage(
      width,
      height,
      startPoint,
      bmpHead!,
      greyImageData!,
    );
    return RotatedBox(
      quarterTurns: -1,
      child: SizedBox(
        width: 400,
        height: 600,
        child: RepaintBoundary(
          child: Image.memory(
            bmpDatanow,
            gaplessPlayback: true,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

  }
}
