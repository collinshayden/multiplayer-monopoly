import 'package:flutter/material.dart';

class SingleDie extends StatelessWidget {
  SingleDie({super.key, required this.value})
      : assert(0 <= value && value <= 6);

  final int value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SingleDiePainter(value: value));
  }
}

class SingleDiePainter extends CustomPainter {
  SingleDiePainter({required this.value});

  final int value;
  static const Map<int, List<FractionalOffset>> dotLocations = {
    0: [],
    1: [
      FractionalOffset(0.5, 0.5),
    ],
    2: [
      FractionalOffset(0.27, 0.27),
      FractionalOffset(1 - 0.27, 1 - 0.27),
    ],
    3: [
      FractionalOffset(0.27, 0.27),
      FractionalOffset(0.5, 0.5),
      FractionalOffset(1 - 0.27, 1 - 0.27),
    ],
    4: [
      FractionalOffset(0.27, 0.27),
      FractionalOffset(1 - 0.27, 0.27),
      FractionalOffset(0.27, 1 - 0.27),
      FractionalOffset(1 - 0.27, 1 - 0.27),
    ],
    5: [
      FractionalOffset(0.27, 0.27),
      FractionalOffset(1 - 0.27, 0.27),
      FractionalOffset(0.5, 0.5),
      FractionalOffset(0.27, 1 - 0.27),
      FractionalOffset(1 - 0.27, 1 - 0.27),
    ],
    6: [],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final Rect background = Offset.zero & size;
    canvas.drawRect(background, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
