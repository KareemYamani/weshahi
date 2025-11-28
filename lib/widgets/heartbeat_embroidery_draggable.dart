import 'package:flutter/material.dart';
import 'golden_heartbeat_painter.dart';

/// HeartbeatEmbroideryDraggable
/// A simple draggable wrapper demonstrating how to place the
/// GoldenHeartbeatPainter within a Stack and drag it around.
///
/// Drop this inside any Stack (e.g., a sash canvas) and control size/initial
/// offset. Dragging is handled via GestureDetector for smooth free-move.
class HeartbeatEmbroideryDraggable extends StatefulWidget {
  const HeartbeatEmbroideryDraggable({
    super.key,
    this.initialOffset = const Offset(40, 40),
    this.size = const Size(220, 60),
    this.color = const Color(0xFFD97706),
    this.seed,
    this.onDelete,
  });

  final Offset initialOffset;
  final Size size;
  final Color color;
  final int? seed;
  final VoidCallback? onDelete;

  @override
  State<HeartbeatEmbroideryDraggable> createState() =>
      _HeartbeatEmbroideryDraggableState();
}

class _HeartbeatEmbroideryDraggableState
    extends State<HeartbeatEmbroideryDraggable> {
  late Offset _pos;
  double _scale = 1.0;
  double _rotation = 0.0;
  bool _selected = false;

  late Offset _startPos;
  late double _startScale;
  late double _startRotation;

  @override
  void initState() {
    super.initState();
    _pos = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pos.dx,
      top: _pos.dy,
      child: GestureDetector(
        onTap: () => setState(() => _selected = !_selected),
        onScaleStart: (details) {
          _startPos = _pos;
          _startScale = _scale;
          _startRotation = _rotation;
        },
        onScaleUpdate: (details) {
          setState(() {
            _pos += details.focalPointDelta;
            _scale = (_startScale * details.scale).clamp(0.6, 2.0);
            _rotation = _startRotation + details.rotation;
          });
        },
        child: RepaintBoundary(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.rotate(
                angle: _rotation,
                child: Transform.scale(
                  scale: _scale,
                  alignment: Alignment.center,
                  child: CustomPaint(
                    size: widget.size,
                    painter: GoldenHeartbeatPainter(
                      strokeWidth: 3.0,
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
      ),
    );
  }
}

/// Example canvas demonstrating usage in a Stack with a sash placeholder.
/// Integrate this widget (or just the HeartbeatEmbroideryDraggable) inside your
/// design screen.
class SashCanvasDemo extends StatelessWidget {
  const SashCanvasDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Stack(
          children: const [
            // Sash placeholder background
            _SashPlaceholder(),

            // Draggable heartbeat embroidery
            HeartbeatEmbroideryDraggable(
              initialOffset: Offset(24, 120),
              size: Size(240, 64),
            ),
          ],
        ),
      ),
    );
  }
}

class _SashPlaceholder extends StatelessWidget {
  const _SashPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SashPainter(),
      size: Size.infinite,
    );
  }
}

class _SashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sashPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFFFFF);

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFFE2E8F0);

    // Simple vertical sash rectangle with slight inset.
    final inset = 20.0;
    final rect = Rect.fromLTWH(
      size.width * 0.25,
      inset,
      size.width * 0.5,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: const Radius.circular(24),
      bottomRight: const Radius.circular(24),
    );
    canvas.drawRRect(rrect, sashPaint);
    canvas.drawRRect(rrect, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
