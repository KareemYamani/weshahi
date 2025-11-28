import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'fingerprint_circular_painter.dart';

/// FingerprintEmbroideryDraggable
/// A circular fingerprint embroidery that can be moved within bounds
/// and deleted. Movement is clamped to the sash area only.
class FingerprintEmbroideryDraggable extends StatefulWidget {
  const FingerprintEmbroideryDraggable({
    super.key,
    required this.boundsSize,
    this.initialOffset = const Offset(10, 10),
    this.diameter = 30,
    required this.color,
    this.seed,
    this.onDelete,
  });

  final Size boundsSize; // Size of parent sash surface
  final Offset initialOffset;
  final double diameter;
  final Color color;
  final int? seed;
  final VoidCallback? onDelete;

  @override
  State<FingerprintEmbroideryDraggable> createState() =>
      _FingerprintEmbroideryDraggableState();
}

class _FingerprintEmbroideryDraggableState
    extends State<FingerprintEmbroideryDraggable> {
  late Offset _pos;
  bool _selected = false;
  double _scale = 1.0;
  double _rotation = 0.0;
  late Offset _startPos;
  late double _startScale;
  late double _startRotation;

  @override
  void initState() {
    super.initState();
    _pos = _clamp(widget.initialOffset, 1.0);
  }

  Offset _clamp(Offset p, double scale) {
    final effective = widget.diameter * scale;
    final double maxX = math.max(0.0, widget.boundsSize.width - effective);
    final double maxY = math.max(0.0, widget.boundsSize.height - effective);
    return Offset(
      p.dx.clamp(0.0, maxX).toDouble(),
      p.dy.clamp(0.0, maxY).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pos.dx,
      top: _pos.dy,
      width: widget.diameter,
      height: widget.diameter,
      child: GestureDetector(
        onTap: () => setState(() => _selected = !_selected),
        onScaleStart: (details) {
          _startPos = _pos;
          _startScale = _scale;
          _startRotation = _rotation;
        },
        onScaleUpdate: (details) {
          final newScale = (_startScale * details.scale).clamp(0.6, 2.0);
          final newPos = _clamp(_startPos + details.focalPointDelta, newScale);
          setState(() {
            _scale = newScale;
            _pos = newPos;
            _rotation = _startRotation + details.rotation;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Transform.rotate(
              angle: _rotation,
              child: Transform.scale(
                scale: _scale,
                child: CustomPaint(
                  size: Size(widget.diameter, widget.diameter),
                  painter: FingerprintCircularPainter(
                    color: widget.color,
                    seed: widget.seed,
                  ),
                ),
              ),
            ),
            if (_selected && widget.onDelete != null)
              Positioned(
                right: -6,
                top: -6,
                child: InkWell(
                  onTap: widget.onDelete,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
