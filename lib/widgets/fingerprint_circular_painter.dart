import 'package:flutter/material.dart';

/// FingerprintCircularPainter
/// Draws a circular fingerprint-like pattern using concentric arcs with gaps.
class FingerprintCircularPainter extends CustomPainter {
  FingerprintCircularPainter({
    required this.color,
    this.strokeWidth = 2.6,
    this.seed,
  });

  final Color color;
  final double strokeWidth;
  final int? seed;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Embroidered thread look: subtle shadow + slight gradient
    final shadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.0
      ..color = const Color(0x55000000)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.4);

    final thread = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        colors: [
          _mix(color, Colors.white, 0.18),
          color,
          _mix(color, Colors.black, 0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rand = _SimpleRandom(seed ?? DateTime.now().microsecondsSinceEpoch);
    final rings = 11;
    for (int i = 0; i < rings; i++) {
      // Elliptical deformation and rotation per ring for realism
      final r = radius * (0.18 + i / (rings + 0.8));
      final rot = (i * 0.12) + rand.nextDouble() * 0.2; // rotation
      final squash = 0.78 + (i * 0.01); // y scale (ellipticity)
      final gaps = 3 + (i % 4);
      final baseAngle = rand.nextDouble() * 6.28318; // 0..2pi

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rot);
      canvas.scale(1.0, squash);

      for (int g = 0; g < gaps; g++) {
        final segLen = 0.5 + rand.nextDouble() * 0.9; // arc length
        final jitter = (rand.nextDouble() - 0.5) * 0.25;
        final start = baseAngle + g * (6.28318 / gaps) + jitter;

        final rect = Rect.fromCircle(center: Offset.zero, radius: r);
        final path = Path()..addArc(rect, start, segLen);

        // subtle offset shadow
        canvas.save();
        canvas.translate(0, 0.8);
        canvas.drawPath(path, shadow);
        canvas.restore();

        // occasional bifurcation: draw a tiny offset sub-arc
        if (rand.nextDouble() > 0.7 && i > 2) {
          final off = 1.8 + rand.nextDouble() * 3.0;
          final smallRect = Rect.fromCircle(center: Offset(off, 0), radius: r * 0.98);
          final smallPath = Path()..addArc(smallRect, start + 0.05, segLen * 0.6);
          canvas.drawPath(smallPath, thread);
        }

        canvas.drawPath(path, thread);
      }
      canvas.restore();
    }

    // Outer ring for clean edge
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = _mix(color, Colors.black, 0.2);
    canvas.drawCircle(center, radius - strokeWidth, ring);
  }

  Color _mix(Color a, Color b, double t) {
    return Color.fromARGB(
      (a.alpha + (b.alpha - a.alpha) * t).round(),
      (a.red + (b.red - a.red) * t).round(),
      (a.green + (b.green - a.green) * t).round(),
      (a.blue + (b.blue - a.blue) * t).round(),
    );
  }

  @override
  bool shouldRepaint(covariant FingerprintCircularPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.seed != seed;
  }
}

class _SimpleRandom {
  _SimpleRandom(int seed) : _state = seed ^ 0x5DEECE66D;
  int _state;
  double nextDouble() {
    _state = (_state * 1664525 + 1013904223) & 0x7fffffff;
    return (_state & 0x7fffff) / 0x7fffff;
  }
}
