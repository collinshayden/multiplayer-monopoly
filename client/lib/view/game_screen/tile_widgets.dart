import 'package:client/view/game_screen/board.dart';
import 'package:flutter/material.dart';

class ImprovableTileWidget extends StatelessWidget {
  ImprovableTileWidget({
    super.key,
    required this.tierColor,
    required this.title,
    required this.price,
  });

  final Color? tierColor;
  final String? title;
  final int? price;

  @override
  Widget build(BuildContext context) {
    final boardTheme = Theme.of(context).extension<BoardTheme>()!;
    return Stack(
      children: [
        CustomPaint(
          painter: _ImprovableTileWidgetPainter(
            boardTheme: boardTheme,
          ),
        ),
        Align(
            alignment: const AlignmentDirectional(0.0, 0.5),
            child: Text(
              title ?? 'null',
              textAlign: TextAlign.center,
              style: boardTheme.textStyle,
            )),
        Align(alignment: const Alignment(0.0, 0.5)),
      ],
    );
    // return Column(
    //   children: [
    //     Flexible(
    //       flex: 1,
    //       child: Container(color: tierColor),
    //     ),
    //     Flexible(
    //       flex: 3,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Text(
    //             title ?? 'Placeholder title',
    //             textAlign: TextAlign.center,
    //             style: boardTheme.textStyle,
    //           ),
    //           Text(
    //             '\$$price',
    //             textAlign: TextAlign.center,
    //             style: boardTheme.textStyle,
    //           )
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }
}

class _ImprovableTileWidgetPainter extends CustomPainter {
  _ImprovableTileWidgetPainter({required this.boardTheme});

  final BoardTheme boardTheme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 0, 0, 0), Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
