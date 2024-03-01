import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'set_app_data.dart';

class DraggableListWheelScrollView extends StatefulWidget {
  const DraggableListWheelScrollView({Key? key}) : super(key: key);

  @override
  DraggableListWheelScrollViewState createState() =>
      DraggableListWheelScrollViewState();
}

class DraggableListWheelScrollViewState
    extends State<DraggableListWheelScrollView> {
  final controller = Get.find<SetAppDataController>();
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  // int selectedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<SetAppDataController>();
      int childCount = 0;
      if (controller.receivedImageData.value != null) {
        int imageDataLength = controller.receivedImageData.value!.length;
        childCount = imageDataLength ~/
            (controller.octWidth.value * controller.octHeight.value);
        // 如果receivedImageData变化了，重置滚轮控件的位置
        _controller.jumpToItem(0);
      }
      return Container(
        margin: const EdgeInsets.all(5),
        width: 70,
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
            magnification: 1.5,
            offAxisFraction: 0,
            diameterRatio: 1.8,
            physics:
                const FixedExtentScrollPhysics(), // 使用FixedExtentScrollPhysics
            onSelectedItemChanged: (index) {
              // setState(() {
              //   selectedNumber = index;
              // });
              Future.microtask(() {
                controller.startPoint.value = index;
              });
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Text(index.toString()),
              childCount: childCount,
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
