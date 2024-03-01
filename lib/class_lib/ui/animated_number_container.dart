import 'package:flutter/material.dart';

class AnimatedNumberContainer extends StatefulWidget {
  final int end;

  const AnimatedNumberContainer({Key? key, required this.end})
      : super(key: key);

  @override
  AnimatedNumberContainerState createState() => AnimatedNumberContainerState();
}

class AnimatedNumberContainerState extends State<AnimatedNumberContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _begin = 0; // 初始值

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = IntTween(begin: _begin, end: widget.end).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumberContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.end != oldWidget.end) {
      // 更新开始值为当前动画值
      _begin = _animation.value;
      _animation = IntTween(begin: _begin, end: widget.end).animate(_controller)
        ..addListener(() {
          setState(() {});
        });

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      // color: Colors.blue[100],
      child: Center(
        child: Text(
          '${_animation.value}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
