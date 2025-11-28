import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../localization/local_manager.dart';

/// FingerprintCaptureModal
/// Simulates capturing a fingerprint via long press with a pulsing
/// fingerprint icon and progress bar.
class FingerprintCaptureModal extends StatefulWidget {
  const FingerprintCaptureModal({
    super.key,
    required this.onCaptured,
    this.captureDuration = const Duration(seconds: 3),
  });

  final VoidCallback onCaptured;
  final Duration captureDuration;

  @override
  State<FingerprintCaptureModal> createState() => _FingerprintCaptureModalState();
}

class _FingerprintCaptureModalState extends State<FingerprintCaptureModal>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _scale;
  late final AnimationController _progressCtrl;
  Timer? _timer;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(begin: 0.9, end: 1.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseCtrl);
    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.captureDuration,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _startCapture() {
    if (_capturing) return;
    setState(() => _capturing = true);
    _pulseCtrl.repeat(reverse: true);
    _progressCtrl
      ..reset()
      ..forward();
    _timer?.cancel();
    // Haptic pulses multiple times during scanning
    _vibrateBurst();
    final periodic = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (!_capturing) {
        t.cancel();
        return;
      }
      HapticFeedback.mediumImpact();
    });

    _timer = Timer(widget.captureDuration, () {
      if (!mounted) return;
      _finish(success: true);
      periodic.cancel();
    });
  }

  void _cancelCapture() {
    if (!_capturing) return;
    _timer?.cancel();
    _pulseCtrl.stop();
    _progressCtrl.reset();
    setState(() => _capturing = false);
  }

  void _finish({required bool success}) {
    _timer?.cancel();
    _pulseCtrl.stop();
    _progressCtrl.stop();
    setState(() => _capturing = false);
    if (success) widget.onCaptured();
  }

  Future<void> _vibrateBurst() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 250));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 250));
      await HapticFeedback.selectionClick();
    } catch (_) {}
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
                onLongPressStart: (_) => _startCapture(),
                onLongPressEnd: (_) => _cancelCapture(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _capturing
                      ? _Capturing(scale: _scale, progress: _progressCtrl)
                      : _Idle(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _capturing
                    ? localManager.tr('design.fingerprint.scanning')
                    : localManager.tr('design.fingerprint.hold_to_capture'),
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

class _Idle extends StatelessWidget {
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
      child: const Icon(Icons.fingerprint, size: 64, color: Color(0xFF0F172A)),
    );
  }
}

class _Capturing extends StatelessWidget {
  const _Capturing({required this.scale, required this.progress});
  final Animation<double> scale;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('capturing'),
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
            scale: scale,
            child: const Icon(
              Icons.fingerprint,
              size: 48,
              color: Color(0xFF0F172A),
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
