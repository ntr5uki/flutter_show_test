import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImagePlayer extends StatefulWidget {
  final Uint8List? imageData;
  final int width, height;

  const ImagePlayer(
      {Key? key,
      required this.imageData,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  ImagePlayerState createState() => ImagePlayerState();
}

class ImagePlayerState extends State<ImagePlayer> {
  int _currentIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  void _togglePlay() {
    if (_isPlaying) {
      _timer?.cancel();
    } else {
      if (widget.imageData != null) {
        _timer = Timer.periodic(Duration(milliseconds: (1000 / 30).round()),
            (timer) {
          setState(() {
            _currentIndex = (_currentIndex + 1) %
                (widget.imageData!.length ~/ (widget.width * widget.height));
          });
        });
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Uint8List currentImage = extractImage(
        widget.imageData!, _currentIndex, widget.width, widget.height);
    return FutureBuilder<ui.Image>(
      future: greyImageToImage(currentImage, widget.width, widget.height),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Column(
            children: [
              CustomPaint(
                painter: ImagePainter(snapshot.data!),
                size: const Size(300, 300),
                // size: Size(widget.width.toDouble(), widget.height.toDouble()),
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlay,
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Uint8List extractImage(Uint8List data, int index, int width, int height) {
    int imgSize = width * height;
    int start = index * imgSize;
    return data.sublist(start, start + imgSize);
  }

  Future<ui.Image> greyImageToImage(
      Uint8List greyImage, int width, int height) async {
    Completer<ui.Image> completer = Completer();
    Uint32List rgba = Uint32List(width * height);
    for (int i = 0; i < greyImage.length; i++) {
      final grey = greyImage[i];
      rgba[i] = (0xFF << 24) | (grey << 16) | (grey << 8) | grey; // RGBA
    }
    ui.decodeImageFromPixels(
      rgba.buffer.asUint8List(),
      width,
      height,
      ui.PixelFormat.rgba8888,
      (image) {
        completer.complete(image);
      },
    );
    return completer.future;
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawImage(image, Offset.zero, ui.Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
