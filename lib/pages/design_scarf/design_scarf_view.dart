import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../localization/local_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../data/design_options.dart';
import '../../models/design_and_order_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/design_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/fingerprint_capture_modal.dart';
import '../../widgets/fingerprint_embroidery_draggable.dart';

class ScarfDesignScreen extends StatefulWidget {
  const ScarfDesignScreen({super.key});

  @override
  State<ScarfDesignScreen> createState() => _ScarfDesignScreenState();
}

class _ScarfDesignScreenState extends State<ScarfDesignScreen> {
  int step = 0;

  String colorId = 'black';
  String fabricId = 'velvet';
  String rightText = 'المهندس أحمد';
  String leftText = '2025';
  String fontId = 'thuluth';
  String fontColorId = 'gold';

  late final TextEditingController _rightTextController;
  late final TextEditingController _leftTextController;

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _rightLogoBytes;
  Uint8List? _leftLogoBytes;
  final GlobalKey<_ScarfSideState> _rightScarfKey =
      GlobalKey<_ScarfSideState>();
  final GlobalKey<_ScarfSideState> _leftScarfKey = GlobalKey<_ScarfSideState>();

  bool _showFingerprintRight = false;
  int? _fingerprintSeedRight;
  bool _showFingerprintLeft = false;
  int? _fingerprintSeedLeft;

  @override
  void initState() {
    super.initState();
    _rightTextController = TextEditingController(text: rightText);
    _leftTextController = TextEditingController(text: leftText);

    _rightTextController.addListener(() {
      setState(() {
        rightText = _rightTextController.text;
      });
    });
    _leftTextController.addListener(() {
      setState(() {
        leftText = _leftTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _rightTextController.dispose();
    _leftTextController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo({required bool isRightSide}) async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      setState(() {
        if (isRightSide) {
          _rightLogoBytes = bytes;
        } else {
          _leftLogoBytes = bytes;
        }
      });
    } catch (e) {
      Get.snackbar(
        localManager.tr('design.error.pick_image_title'),
        localManager.tr('design.error.pick_image_desc'),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _openFingerprintCapture({required bool addToRight}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FingerprintCaptureModal(
        onCaptured: () {
          Navigator.of(context).pop();
          setState(() {
            if (addToRight) {
              _showFingerprintRight = true;
              _fingerprintSeedRight = DateTime.now().microsecondsSinceEpoch;
            } else {
              _showFingerprintLeft = true;
              _fingerprintSeedLeft = DateTime.now().microsecondsSinceEpoch;
            }
          });
          Get.snackbar(
            localManager.tr('design.fingerprint.action'),
            localManager.tr('design.fingerprint.added'),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }

  ScarfColor get activeColor => scarfColors.firstWhere(
    (c) => c.id == colorId,
    orElse: () => scarfColors.first,
  );

  EmbroideryColor get activeFontColor => embroideryColors.firstWhere(
    (c) => c.id == fontColorId,
    orElse: () => embroideryColors.first,
  );

  ArabicFontOption get activeFont => fontOptions.firstWhere(
    (f) => f.id == fontId,
    orElse: () => fontOptions.first,
  );

  bool get isSatin => fabricId == 'satin';

  double _fontSizeFor(String text) {
    const base = 22.0;
    if (text.isEmpty) return base;
    if (text.length <= 6) return base;
    final reduced = base - (text.length - 6) * 0.8;
    return reduced.clamp(12.0, base);
  }

  void _goNext() {
    if (step < 3) {
      setState(() {
        step++;
      });
    } else {
      final design = ScarfDesignData(
        colorId: colorId,
        fabricId: fabricId,
        rightText: rightText,
        leftText: leftText,
        fontId: fontId,
        fontColorId: fontColorId,
      );

      Get.find<DesignController>().updateScarf(design);
      Get.toNamed(Routes.order, arguments: DesignItemType.scarf);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            DesignAppBar(title: localManager.tr('design.scarf.title'), onBack: Get.back),
            Expanded(
              child: Column(
                children: [
                  _ScarfPreview(
                    color: activeColor.color,
                    fabricId: fabricId,
                    rightText: rightText,
                    leftText: leftText,
                    fontColor: activeFontColor.color,
                    fontSizeRight: _fontSizeFor(rightText),
                    fontSizeLeft: _fontSizeFor(leftText),
                    rightLogoBytes: _rightLogoBytes,
                    leftLogoBytes: _leftLogoBytes,
                    rightKey: _rightScarfKey,
                    leftKey: _leftScarfKey,
                    showFingerprintRight: _showFingerprintRight,
                    fingerprintSeedRight: _fingerprintSeedRight,
                    onRemoveFingerprintRight: () {
                      setState(() {
                        _showFingerprintRight = false;
                        _fingerprintSeedRight = null;
                      });
                    },
                    showFingerprintLeft: _showFingerprintLeft,
                    fingerprintSeedLeft: _fingerprintSeedLeft,
                    onRemoveFingerprintLeft: () {
                      setState(() {
                        _showFingerprintLeft = false;
                        _fingerprintSeedLeft = null;
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 20,
                            offset: Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          StepsHeader(
                            steps: const [
                              'القماش واللون',
                              'النص',
                              'الشعارات',
                              'تأكيد',
                            ],
                            current: step,
                            onTap: (i) => setState(() => step = i),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _buildStepContent(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: PrimaryButton(
                              label: step < 3
                                  ? localManager.tr('common.next')
                                  : localManager.tr('order.title'),
                              onPressed: _goNext,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (step == 0) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اختر نوع القماش',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: fabricOptions.map((fabric) {
              final selected = fabricId == fabric.id;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => fabricId = fabric.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          fabric.name,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.textMain,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fabric.description,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: selected
                                ? Colors.white70
                                : AppColors.textSec,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اختر لون الوشاح',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: scarfColors.map((color) {
              final selected = colorId == color.id;
              return GestureDetector(
                onTap: () => setState(() => colorId = color.id),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.6),
                      width: selected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (step == 1) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الطرف الأيمن',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'مثال: المهندس أحمد',
                      ),
                      controller: _rightTextController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الطرف الأيسر',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'مثال: دفعة 2025',
                      ),
                      controller: _leftTextController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'لون خيوط التطريز',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: embroideryColors.map((c) {
              final selected = fontColorId == c.id;
              return GestureDetector(
                onTap: () => setState(() => fontColorId = c.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'نوع الخط العربي',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: fontOptions.map((f) {
              final selected = fontId == f.id;
              return ChoiceChip(
                label: Text(f.name),
                selected: selected,
                onSelected: (_) => setState(() => fontId = f.id),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (step == 2) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          _LogoUploadTile(
            title: 'شعار الطرف الأيمن',
            subtitle: 'اضغط للرفع',
            bytes: _rightLogoBytes,
            onPick: () => _pickLogo(isRightSide: true),
            onRemove: _rightLogoBytes == null
                ? null
                : () {
                    setState(() {
                      _rightLogoBytes = null;
                    });
                  },
          ),
          const SizedBox(height: 12),
          _LogoUploadTile(
            title: 'شعار الطرف الأيسر',
            subtitle: 'اضغط للرفع',
            bytes: _leftLogoBytes,
            onPick: () => _pickLogo(isRightSide: false),
            onRemove: _leftLogoBytes == null
                ? null
                : () {
                    setState(() {
                      _leftLogoBytes = null;
                    });
                  },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FingerprintTile(
                  title: localManager.tr('design.fingerprint.action'),
                  subtitle:
                      localManager.tr('design.fingerprint.hold_to_capture'),
                  onTap: () => _openFingerprintCapture(addToRight: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FingerprintTile(
                  title: localManager.tr('design.fingerprint.action'),
                  subtitle:
                      localManager.tr('design.fingerprint.hold_to_capture'),
                  onTap: () => _openFingerprintCapture(addToRight: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _LogoControlsRow(
            title: 'تحكم شعار الطرف الأيمن',
            enabled: _rightLogoBytes != null,
            onZoomIn: () => _rightScarfKey.currentState?.adjustScale(0.1),
            onZoomOut: () => _rightScarfKey.currentState?.adjustScale(-0.1),
            onRotateLeft: () =>
                _rightScarfKey.currentState?.adjustRotation(-0.15),
            onRotateRight: () =>
                _rightScarfKey.currentState?.adjustRotation(0.15),
          ),
          const SizedBox(height: 8),
          _LogoControlsRow(
            title: 'تحكم شعار الطرف الأيسر',
            enabled: _leftLogoBytes != null,
            onZoomIn: () => _leftScarfKey.currentState?.adjustScale(0.1),
            onZoomOut: () => _leftScarfKey.currentState?.adjustScale(-0.1),
            onRotateLeft: () =>
                _leftScarfKey.currentState?.adjustRotation(-0.15),
            onRotateRight: () =>
                _leftScarfKey.currentState?.adjustRotation(0.15),
          ),
          const SizedBox(height: 16),
          const Text(
            'يمكنك سحب الشعارات وتكبيرها وتدويرها مباشرة من منطقة المعاينة في الأعلى.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSec),
          ),
        ],
      );
    }

    final fabricName = fabricOptions
        .firstWhere((f) => f.id == fabricId, orElse: () => fabricOptions.first)
        .name;

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ملخص التصميم',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 10),
              SummaryRow(label: 'القماش', value: fabricName),
              SummaryRow(label: 'اللون', value: activeColor.name),
              SummaryRow(label: 'النص', value: '$rightText / $leftText'),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Text(
                    '150,000 ل.س',
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'السعر النهائي',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScarfPreview extends StatelessWidget {
  final Color color;
  final String fabricId;
  final String rightText;
  final String leftText;
  final Color fontColor;
  final double fontSizeRight;
  final double fontSizeLeft;
  final Uint8List? rightLogoBytes;
  final Uint8List? leftLogoBytes;
  final GlobalKey<_ScarfSideState>? rightKey;
  final GlobalKey<_ScarfSideState>? leftKey;
  final bool showFingerprintRight;
  final int? fingerprintSeedRight;
  final VoidCallback? onRemoveFingerprintRight;
  final bool showFingerprintLeft;
  final int? fingerprintSeedLeft;
  final VoidCallback? onRemoveFingerprintLeft;

  const _ScarfPreview({
    required this.color,
    required this.fabricId,
    required this.rightText,
    required this.leftText,
    required this.fontColor,
    required this.fontSizeRight,
    required this.fontSizeLeft,
    this.rightLogoBytes,
    this.leftLogoBytes,
    this.rightKey,
    this.leftKey,
    this.showFingerprintRight = false,
    this.fingerprintSeedRight,
    this.onRemoveFingerprintRight,
    this.showFingerprintLeft = false,
    this.fingerprintSeedLeft,
    this.onRemoveFingerprintLeft,
  });

  bool get isSatin => fabricId == 'satin';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFFE5E7EB)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScarfSide(
              key: rightKey,
              color: color,
              isSatin: isSatin,
              text: rightText,
              fontColor: fontColor,
              fontSize: fontSizeRight,
              rotateRight: true,
              logoBytes: rightLogoBytes,
              showFingerprint: showFingerprintRight,
              fingerprintSeed: fingerprintSeedRight,
              onRemoveFingerprint: onRemoveFingerprintRight,
            ),
            const SizedBox(width: 14),
            _ScarfSide(
              key: leftKey,
              color: color,
              isSatin: isSatin,
              text: leftText,
              fontColor: fontColor,
              fontSize: fontSizeLeft,
              rotateRight: false,
              logoBytes: leftLogoBytes,
              showFingerprint: showFingerprintLeft,
              fingerprintSeed: fingerprintSeedLeft,
              onRemoveFingerprint: onRemoveFingerprintLeft,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScarfSide extends StatefulWidget {
  final Color color;
  final bool isSatin;
  final String text;
  final Color fontColor;
  final double fontSize;
  final bool rotateRight;
  final Uint8List? logoBytes;
  final bool showFingerprint;
  final int? fingerprintSeed;
  final VoidCallback? onRemoveFingerprint;

  const _ScarfSide({
    super.key,
    required this.color,
    required this.isSatin,
    required this.text,
    required this.fontColor,
    required this.fontSize,
    required this.rotateRight,
    this.logoBytes,
    this.showFingerprint = false,
    this.fingerprintSeed,
    this.onRemoveFingerprint,
  });

  @override
  State<_ScarfSide> createState() => _ScarfSideState();
}

class _ScarfSideState extends State<_ScarfSide> {
  Offset _logoOffset = Offset.zero;
  double _logoScale = 1;
  double _logoRotation = 0;
  Offset _textOffset = Offset.zero;

  late Offset _startFocalPoint;
  late Offset _startOffset;
  late double _startScale;
  late double _startRotation;

  @override
  void didUpdateWidget(covariant _ScarfSide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logoBytes != widget.logoBytes && widget.logoBytes != null) {
      // Reset transform when a new logo is added.
      _logoOffset = Offset.zero;
      _logoScale = 1;
      _logoRotation = 0;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startFocalPoint = details.focalPoint;
    _startOffset = _logoOffset;
    _startScale = _logoScale;
    _startRotation = _logoRotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final delta = details.focalPoint - _startFocalPoint;
    setState(() {
      _logoOffset = _clampOffset(_startOffset + delta);
      _logoScale = (_startScale * details.scale).clamp(0.6, 2.4);
      _logoRotation = _startRotation + details.rotation;
    });
  }

  void adjustScale(double delta) {
    setState(() {
      _logoScale = (_logoScale + delta).clamp(0.6, 2.4);
    });
  }

  void adjustRotation(double delta) {
    setState(() {
      _logoRotation += delta;
    });
  }

  Offset _clampOffset(Offset offset) {
    const dxLimit = 18.0;
    const dyLimit = 60.0;
    return Offset(
      offset.dx.clamp(-dxLimit, dxLimit),
      offset.dy.clamp(-dyLimit, dyLimit),
    );
  }

  Offset _clampTextOffset(Offset offset) {
    const dxLimit = 20.0;
    const dyLimit = 70.0;
    return Offset(
      offset.dx.clamp(-dxLimit, dxLimit),
      offset.dy.clamp(-dyLimit, dyLimit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 210,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
        gradient: widget.isSatin
            ? const LinearGradient(
                colors: [Colors.black54, Colors.white24, Colors.black45],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Transform.translate(
                offset: _textOffset,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _textOffset = _clampTextOffset(
                        _textOffset + details.delta,
                      );
                    });
                  },
                  child: Transform.rotate(
                    angle: widget.rotateRight ? -3.14 / 2 : 3.14 / 2,
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: widget.fontColor,
                        fontWeight: FontWeight.w800,
                        fontSize: widget.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.logoBytes != null)
            Positioned.fill(
              child: Center(
                child: Transform.translate(
                  offset: _logoOffset,
                  child: GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    child: Transform.rotate(
                      angle: _logoRotation,
                      child: Transform.scale(
                        scale: _logoScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            widget.logoBytes!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.showFingerprint)
            FingerprintEmbroideryDraggable(
              boundsSize: const Size(70, 210),
              initialOffset: const Offset(18, 90),
              diameter: 30,
              color: widget.fontColor,
              seed: widget.fingerprintSeed,
              onDelete: widget.onRemoveFingerprint,
            ),
          Positioned(
            bottom: 6,
            left: 26,
            right: 26,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoUploadTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? bytes;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  const _LogoUploadTile({
    required this.title,
    required this.subtitle,
    required this.bytes,
    required this.onPick,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = bytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPick,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                if (hasLogo) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      bytes!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else ...[
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.textSec,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        hasLogo ? 'تم إضافة الشعار، اضغط لتغييره' : subtitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'يُفضل شعار شفاف (PNG)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLogo && onRemove != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoControlsRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  const _LogoControlsRow({
    required this.title,
    required this.enabled,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRotateLeft,
    required this.onRotateRight,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = enabled
        ? AppColors.primary
        : AppColors.textSec.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildControlButton(
              icon: Icons.zoom_out,
              color: iconColor,
              enabled: enabled,
              onTap: onZoomOut,
            ),
            _buildControlButton(
              icon: Icons.zoom_in,
              color: iconColor,
              enabled: enabled,
              onTap: onZoomIn,
            ),
            _buildControlButton(
              icon: Icons.rotate_left,
              color: iconColor,
              enabled: enabled,
              onTap: onRotateLeft,
            ),
            _buildControlButton(
              icon: Icons.rotate_right,
              color: iconColor,
              enabled: enabled,
              onTap: onRotateRight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 42,
      height: 36,
      child: OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: enabled ? const Color(0xFFE2E8F0) : const Color(0xFFE5E7EB),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _FingerprintTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FingerprintTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE68A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSec,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left_rounded, color: AppColors.textSec),
          ],
        ),
      ),
    );
  }
}
