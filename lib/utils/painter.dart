
import 'package:flutter/material.dart';

class HeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(0xffBA68C8);
    path = Path();
    path.lineTo(0, size.height * 0.94);
    path.cubicTo(
        0, size.height * 0.83, 0, size.height * 0.01, 0, size.height * 0.01);
    path.cubicTo(0, size.height * 0.01, size.width / 2, size.height * 0.01,
        size.width / 2, size.height * 0.01);
    path.cubicTo(size.width / 2, size.height * 0.01, size.width,
        size.height * 0.01, size.width, size.height * 0.01);
    path.cubicTo(size.width, size.height * 0.01, size.width, size.height * 0.9,
        size.width, size.height * 0.9);
    path.cubicTo(size.width, size.height * 0.73, size.width * 0.92,
        size.height * 0.49, size.width * 0.89, size.height * 0.46);
    path.cubicTo(size.width * 0.86, size.height * 0.43, size.width * 0.85,
        size.height * 0.43, size.width * 0.81, size.height * 0.46);
    path.cubicTo(size.width * 0.77, size.height * 0.49, size.width * 0.57,
        size.height * 0.8, size.width * 0.45, size.height * 0.92);
    path.cubicTo(size.width * 0.34, size.height * 1.03, 0, size.height * 1.04,
        0, size.height * 0.94);
    path.cubicTo(
        0, size.height * 0.94, 0, size.height * 0.94, 0, size.height * 0.94);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Color(0xff6A1B9A);
    path = Path();
    path.lineTo(0, size.height * 0.68);
    path.cubicTo(0, size.height * 0.58, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.65, size.width,
        size.height * 0.65);
    path.cubicTo(size.width, size.height * 0.47, size.width * 0.92,
        size.height * 0.24, size.width * 0.89, size.height / 5);
    path.cubicTo(size.width * 0.86, size.height * 0.18, size.width * 0.85,
        size.height * 0.18, size.width * 0.81, size.height / 5);
    path.cubicTo(size.width * 0.77, size.height * 0.24, size.width * 0.57,
        size.height * 0.55, size.width * 0.45, size.height * 0.66);
    path.cubicTo(size.width * 0.34, size.height * 0.78, 0, size.height * 0.79,
        0, size.height * 0.68);
    path.cubicTo(
        0, size.height * 0.68, 0, size.height * 0.68, 0, size.height * 0.68);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
