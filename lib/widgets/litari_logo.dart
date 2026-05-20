import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LitariLogo extends StatelessWidget {
  final bool showName;
  final double size;

  const LitariLogo({
    super.key,
    this.showName = false,
    this.size = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _MascotPainter()),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          const Text('LITARI', style: AppTextStyles.appName),
        ],
      ],
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Body
    final bodyPaint = Paint()..color = const Color(0xFFE07B3A);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 18), width: 72, height: 80),
      bodyPaint,
    );

    // Head
    canvas.drawCircle(Offset(cx, cy - 15), 38, bodyPaint);

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFF5DEB3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 20), width: 42, height: 50),
      bellyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 12), width: 44, height: 36),
      bellyPaint,
    );

    // Ears
    final earBasePaint = Paint()..color = const Color(0xFFE07B3A);
    final earInnerPaint = Paint()..color = const Color(0xFFD4622A);
    canvas.drawCircle(Offset(cx - 28, cy - 46), 13, earBasePaint);
    canvas.drawCircle(Offset(cx + 28, cy - 46), 13, earBasePaint);
    canvas.drawCircle(Offset(cx - 28, cy - 46), 8, earInnerPaint);
    canvas.drawCircle(Offset(cx + 28, cy - 46), 8, earInnerPaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF3D1A00);
    canvas.drawCircle(Offset(cx - 11, cy - 18), 6, eyePaint);
    canvas.drawCircle(Offset(cx + 11, cy - 18), 6, eyePaint);
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 8.5, cy - 21), 2, shinePaint);
    canvas.drawCircle(Offset(cx + 13.5, cy - 21), 2, shinePaint);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFF5C2A00);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 10, height: 7),
      nosePaint,
    );

    // Cape
    final capePaint = Paint()..color = const Color(0xFFC0392B);
    final capePath = Path()
      ..moveTo(cx - 36, cy + 4)
      ..quadraticBezierTo(cx, cy + 65, cx + 36, cy + 4)
      ..quadraticBezierTo(cx + 24, cy + 58, cx, cy + 70)
      ..quadraticBezierTo(cx - 24, cy + 58, cx - 36, cy + 4)
      ..close();
    canvas.drawPath(capePath, capePaint);

    // Cape knot
    final knotPaint = Paint()..color = const Color(0xFF8B1A1A);
    canvas.drawCircle(Offset(cx, cy + 6), 5, knotPaint);

    // Tail
    final tailPath = Path()
      ..moveTo(cx + 34, cy + 22)
      ..cubicTo(cx + 65, cy + 8, cx + 72, cy - 16, cx + 56, cy - 32);
    canvas.drawPath(
      tailPath,
      bodyPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );
    // Stripes
    final stripeP = Paint()
      ..color = const Color(0xFF5C2A00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + 50, cy + 6), Offset(cx + 62, cy - 2), stripeP);
    canvas.drawLine(Offset(cx + 60, cy - 16), Offset(cx + 68, cy - 26), stripeP);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
