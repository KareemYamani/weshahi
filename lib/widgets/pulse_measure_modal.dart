import 'dart:async';
import 'package:flutter/material.dart';
import '../localization/local_manager.dart';

/// PulseMeasureModal
/// A modal-like widget that simulates pulse measurement when the user
/// long-presses the fingerprint icon.
///
/// Usage (e.g., in a bottom sheet or dialog):
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => const PulseMeasureModal(
///     onMeasured: _onPulseMeasured,
///   ),
/// );
class PulseMeasureModal extends StatefulWidget {
  const PulseMeasureModal({
    super.key,
    required this.onMeasured,
    this.measureDuration = const Duration(seconds: 3),
  });

  /// Callback fired when measurement completes successfully.
  final VoidCallback onMeasured;

  /// How long to "measure" for.
  final Duration measureDuration;

  @override
  State<PulseMeasureModal> createState() => _PulseMeasureModalState();
}

class _PulseMeasureModalState extends State<PulseMeasureModal>
    with TickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double> _heartScale;

  late final AnimationController _progressCtrl;

  Timer? _timer;
  bool _measuring = false;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartScale = Tween<double>(begin: 0.9, end: 1.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_heartCtrl);

    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.measureDuration,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heartCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _startMeasure() {
    if (_measuring) return;
    setState(() => _measuring = true);

    _heartCtrl.repeat(reverse: true);
    _progressCtrl
      ..reset()
      ..forward();

    _timer?.cancel();
    _timer = Timer(widget.measureDuration, () {
      if (!mounted) return;
      _finishMeasure(success: true);
    });
  }

  void _cancelMeasure() {
    if (!_measuring) return;
    _timer?.cancel();
    _heartCtrl.stop();
    _progressCtrl.reset();
    setState(() => _measuring = false);
  }

  void _finishMeasure({required bool success}) {
    _timer?.cancel();
    _heartCtrl.stop();
    _progressCtrl.stop();
    setState(() => _measuring = false);
    if (success) widget.onMeasured();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onLongPressStart: (_) => _startMeasure(),
                onLongPressEnd: (_) => _cancelMeasure(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _measuring
                      ? _MeasuringContent(
                          heartScale: _heartScale,
                          progress: _progressCtrl,
                        )
                      : _IdleContent(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _measuring
                    ? localManager.tr('design.heartbeat.measuring')
                    : localManager.tr('design.heartbeat.hold_to_measure'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.fingerprint, size: 64, color: Color(0xFF0F172A)),
        ],
      ),
    );
  }
}

class _MeasuringContent extends StatelessWidget {
  const _MeasuringContent({
    required this.heartScale,
    required this.progress,
  });

  final Animation<double> heartScale;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('measuring'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: heartScale,
            child: const Icon(
              Icons.favorite_rounded,
              size: 48,
              color: Color(0xFFDC2626),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 200,
            child: AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: progress.value,
                  backgroundColor: const Color(0xFFFDE68A),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
                  borderRadius: BorderRadius.circular(10),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
