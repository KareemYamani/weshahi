import 'package:flutter/material.dart';

/// GoldenHeartbeatPainter
/// Draws a stylized ECG waveform with a golden embroidery look.
///
/// Style:
/// - Primary gold: 0xFFD97706
/// - Subtle shadow for 3D thread effect
/// - Stroke width ~3.0
class GoldenHeartbeatPainter extends CustomPainter {
  GoldenHeartbeatPainter({
    this.strokeWidth = 3.0,
    this.color = const Color(0xFFD97706),
    this.shadowColor = const Color(0xFFB45309),
    this.seed,
  });

  final double strokeWidth;
  final Color color;
  final Color shadowColor;
  final int? seed; // Different seed => different heartbeat

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildEcgPath(size);

    // Draw slight shadow/embroidery depth
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.2
      ..color = shadowColor.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    canvas.save();
    // Slight vertical offset to fake a stitched thread shadow
    canvas.translate(0, 1.0);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Main golden thread
    final goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        colors: [
          _mix(color, Colors.white, 0.15),
          color,
          _mix(color, Colors.black, 0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, goldPaint);
  }

  /// Builds a repeated ECG-like path spanning the full width.
  /// Pattern: baseline -> small bump -> big spike -> recovery -> baseline.
  Path _buildEcgPath(Size size) {
    final w = size.width;
    final h = size.height;
    final centerY = h * 0.5;

    final rand = _SimpleRandom(seed ?? DateTime.now().microsecondsSinceEpoch);

    final basePattern = 80.0;
    final p = Path();
    p.moveTo(0, centerY);

    double x = 0.0;
    while (x < w) {
      final patternWidth = basePattern * (0.85 + rand.nextDouble() * 0.4); // 0.85..1.25x
      final startX = x;
      final peakHeight = h * (0.28 + rand.nextDouble() * 0.18); // 28%..46%
      final smallBump = h * (0.08 + rand.nextDouble() * 0.12); // 8%..20%

      // 1) Baseline slight rise
      p.lineTo(startX + patternWidth * 0.15, centerY - smallBump * (0.2 + rand.nextDouble() * 0.4));

      // 2) Pre bump down
      p.lineTo(startX + patternWidth * 0.25, centerY + smallBump);

      // 3) Sharp up spike
      p.lineTo(startX + patternWidth * (0.30 + rand.nextDouble() * 0.06), centerY - peakHeight);

      // 4) Sharp fall
      p.lineTo(startX + patternWidth * (0.38 + rand.nextDouble() * 0.06), centerY + smallBump * (0.5 + rand.nextDouble() * 0.4));

      // 5) Overshoot dip
      p.lineTo(startX + patternWidth * (0.46 + rand.nextDouble() * 0.06), centerY - smallBump * (0.6 + rand.nextDouble() * 0.6));

      // 6) Recover to baseline
      p.lineTo(startX + patternWidth * (0.60 + rand.nextDouble() * 0.06), centerY);

      // 7) Gentle baseline to end of pattern
      p.lineTo(startX + patternWidth, centerY);

      x += patternWidth;
    }
    return p;
  }

  // Mix color with another by [t] (0..1)
  Color _mix(Color a, Color b, double t) {
    return Color.fromARGB(
      (a.alpha + (b.alpha - a.alpha) * t).round(),
      (a.red + (b.red - a.red) * t).round(),
      (a.green + (b.green - a.green) * t).round(),
      (a.blue + (b.blue - a.blue) * t).round(),
    );
  }

  @override
  bool shouldRepaint(covariant GoldenHeartbeatPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.seed != seed;
  }
}

// Lightweight predictable random for visual variety.
class _SimpleRandom {
  _SimpleRandom(int seed) : _state = seed ^ 0x5DEECE66D;
  int _state;
  // 0..1
  double nextDouble() {
    _state = (_state * 1664525 + 1013904223) & 0x7fffffff;
    return (_state & 0x7fffff) / 0x7fffff;
  }
}
