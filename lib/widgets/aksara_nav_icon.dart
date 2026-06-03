import 'package:flutter/material.dart';

class AksaraNavIcon extends StatelessWidget {
  final Color color;
  const AksaraNavIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _AksaraPainter(color: color),
    );
  }
}

class _AksaraPainter extends CustomPainter {
  final Color color;
  const _AksaraPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Aksara "ka" ᮊ — disederhanakan jadi bentuk ikonik
    // Garis atas horizontal
    canvas.drawLine(Offset(w * 0.15, h * 0.22), Offset(w * 0.85, h * 0.22), paint);

    // Garis kiri turun
    canvas.drawLine(Offset(w * 0.25, h * 0.22), Offset(w * 0.25, h * 0.62), paint);

    // Garis kanan turun
    canvas.drawLine(Offset(w * 0.75, h * 0.22), Offset(w * 0.75, h * 0.62), paint);

    // Garis tengah horizontal (ciri khas aksara sunda)
    canvas.drawLine(Offset(w * 0.25, h * 0.50), Offset(w * 0.75, h * 0.50), paint);

    // Ekor bawah kiri melengkung ke kanan
    final path = Path()
      ..moveTo(w * 0.25, h * 0.62)
      ..quadraticBezierTo(w * 0.25, h * 0.82, w * 0.50, h * 0.82)
      ..quadraticBezierTo(w * 0.75, h * 0.82, w * 0.75, h * 0.62);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AksaraPainter old) => old.color != color;
}
