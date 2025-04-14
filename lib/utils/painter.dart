import 'package:flutter/material.dart';

class HeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(0xffBA68C8);
    path = Path();
    path.lineTo(0, size.height * 1.12);
    path.cubicTo(0, size.height, 0, size.height * 0.26, 0, size.height * 0.26);
    path.cubicTo(0, size.height * 0.26, size.width, size.height * 0.26,
        size.width, size.height * 0.26);
    path.cubicTo(size.width, size.height * 0.26, size.width, size.height * 1.08,
        size.width, size.height * 1.08);
    path.cubicTo(size.width, size.height * 0.86, size.width * 0.93,
        size.height * 0.74, size.width * 0.9, size.height * 0.71);
    path.cubicTo(size.width * 0.86, size.height * 0.67, size.width * 0.84,
        size.height * 0.67, size.width * 0.8, size.height * 0.71);
    path.cubicTo(size.width * 0.75, size.height * 0.74, size.width * 0.6,
        size.height * 0.98, size.width * 0.45, size.height * 1.16);
    path.cubicTo(size.width * 0.31, size.height * 1.35, 0, size.height * 1.25,
        0, size.height * 1.12);
    path.cubicTo(
        0, size.height * 1.12, 0, size.height * 1.12, 0, size.height * 1.12);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Color(0xff6A1B9A);
    path = Path();
    path.lineTo(0, size.height * 0.85);
    path.cubicTo(0, size.height * 0.73, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.81, size.width,
        size.height * 0.81);
    path.cubicTo(size.width, size.height * 0.59, size.width * 0.93,
        size.height * 0.48, size.width * 0.9, size.height * 0.44);
    path.cubicTo(size.width * 0.86, size.height * 0.41, size.width * 0.84,
        size.height * 0.41, size.width * 0.8, size.height * 0.44);
    path.cubicTo(size.width * 0.75, size.height * 0.48, size.width * 0.6,
        size.height * 0.71, size.width * 0.45, size.height * 0.9);
    path.cubicTo(size.width * 0.31, size.height * 1.08, 0, size.height * 0.98,
        0, size.height * 0.85);
    path.cubicTo(
        0, size.height * 0.85, 0, size.height * 0.85, 0, size.height * 0.85);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
