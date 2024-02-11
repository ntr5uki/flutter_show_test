import 'package:flutter/material.dart';

class DraggableListWheelScrollView extends StatefulWidget {
  final Function(int) onNumberSelected;

  DraggableListWheelScrollView({Key? key, required this.onNumberSelected})
      : super(key: key);

  @override
  _DraggableListWheelScrollViewState createState() =>
      _DraggableListWheelScrollViewState();
}

class _DraggableListWheelScrollViewState
    extends State<DraggableListWheelScrollView> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  int selectedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 350,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          _controller.jumpTo(_controller.offset - details.primaryDelta!);
        },
        onVerticalDragEnd: (details) {
          // 可选：在这里处理拖动结束后的逻辑
        },
        child: ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 30,
          useMagnifier: true,
          magnification: 1.1,
          offAxisFraction: 0.2,
          diameterRatio: 1.5,
          physics: FixedExtentScrollPhysics(), // 使用FixedExtentScrollPhysics
          onSelectedItemChanged: (index) {
            setState(() {
              selectedNumber = index;
            });
            widget.onNumberSelected(index);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) => Text(index.toString()),
            childCount: 100,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
