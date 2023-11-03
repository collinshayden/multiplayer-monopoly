import 'package:flutter/material.dart';

class SingleDie extends StatelessWidget {
  SingleDie({super.key, required this.value})
      : assert(0 <= value && value <= 6);

  final int value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SingleDiePainter(value: value),
        child: Container(width: 450, height: 450));
  }
}

class SingleDiePainter extends CustomPainter {
  SingleDiePainter({required this.value});

  final int value;
  static const dotSpacing =
      0.5; // Fractional distance from center to the respective x and y coordinates.
  static const dotRadius = 0.083;
  static const Map<int, List<Alignment>> dotAlignments = {
    0: [],
    1: [
      Alignment(0.0, 0.0),
    ],
    2: [
      Alignment(-dotSpacing, -dotSpacing),
      Alignment(dotSpacing, dotSpacing),
    ],
    3: [
      Alignment(-dotSpacing, -dotSpacing),
      Alignment(0.0, 0.0),
      Alignment(dotSpacing, dotSpacing),
    ],
    4: [
      Alignment(-dotSpacing, -dotSpacing),
      Alignment(dotSpacing, -dotSpacing),
      Alignment(-dotSpacing, dotSpacing),
      Alignment(dotSpacing, dotSpacing),
    ],
    5: [
      Alignment(-dotSpacing, -dotSpacing),
      Alignment(dotSpacing, -dotSpacing),
      Alignment(0.0, 0.0),
      Alignment(-dotSpacing, dotSpacing),
      Alignment(dotSpacing, dotSpacing),
    ],
    6: [
      Alignment(-dotSpacing, -dotSpacing),
      Alignment(dotSpacing, -dotSpacing),
      Alignment(-dotSpacing, 0.0),
      Alignment(dotSpacing, 0.0),
      Alignment(-dotSpacing, dotSpacing),
      Alignment(dotSpacing, dotSpacing),
    ],
  };

  void _paintDots(Canvas canvas, Size size, int value) {
    dotAlignments[value]!.forEach(
      (Alignment dotAlignment) {
        canvas.drawCircle(
          dotAlignment.alongSize(size),
          dotRadius * size.width,
          Paint()..color = Colors.black,
        );
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect background = Offset.zero & size;
    canvas.drawRect(background, Paint()..color = Colors.white);
    _paintDots(canvas, size, value);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[200],
        body: Center(child: SingleDie(value: 6)),
      ),
    ),
  );
}
