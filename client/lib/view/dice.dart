import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  const Dice({
    super.key,
    required this.first,
    required this.second,
  });

  final int first;
  final int second;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SingleDie(value: first), SingleDie(value: second)],
        ),
      ),
    );
  }
}

class SingleDie extends StatelessWidget {
  const SingleDie({super.key, required this.value})
      : assert(0 <= value && value <= 6);

  final int value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SingleDiePainter(value: value),
        child: const AspectRatio(aspectRatio: 1 / 1));
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
    final background = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.width / 10),
    );
    canvas.drawRRect(
      background,
      Paint()..color = Colors.white,
    );
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
        body: Center(
          child: SizedBox(
              width: 400,
              height: 200,
              child: Dice(
                first: 2,
                second: 4,
              )),
        ),
      ),
    ),
  );
}
