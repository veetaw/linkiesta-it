import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 18, right: 14),
      child: CustomPaint(
        willChange: false,
        painter: _MenuIconPainter(),
        size: Size(30, 30),
      ),
    );
  }
}

class _MenuIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(0, 10), Offset(size.width / 2, 10), paint);
    canvas.drawLine(Offset(0, 20), Offset(size.width, 20), paint);
  }

  @override
  bool shouldRepaint(_MenuIconPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_MenuIconPainter oldDelegate) => false;
}
