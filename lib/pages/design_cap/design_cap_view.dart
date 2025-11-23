import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../data/design_options.dart';
import '../../models/design_and_order_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/design_app_bar.dart';
import '../../widgets/primary_button.dart';

class CapDesignScreen extends StatefulWidget {
  const CapDesignScreen({super.key});

  @override
  State<CapDesignScreen> createState() => _CapDesignScreenState();
}

class _CapDesignScreenState extends State<CapDesignScreen> {
  int step = 0;

  String colorId = 'black';
  String fabricId = 'velvet';
  String tasselColorId = 'gold';
  String topText = 'خريج 2025';
  String fontId = 'thuluth';
  String fontColorId = 'gold';
  double _textRotation = 0;

  final GlobalKey<_CapPreviewState> _capPreviewKey =
      GlobalKey<_CapPreviewState>();

  late final TextEditingController _topTextController;

  @override
  void initState() {
    super.initState();
    _topTextController = TextEditingController(text: topText);
    _topTextController.addListener(() {
      setState(() {
        topText = _topTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _topTextController.dispose();
    super.dispose();
  }

  ScarfColor get activeColor => scarfColors.firstWhere(
    (c) => c.id == colorId,
    orElse: () => scarfColors.first,
  );

  TasselColor get activeTassel => tasselColors.firstWhere(
    (c) => c.id == tasselColorId,
    orElse: () => tasselColors.first,
  );

  EmbroideryColor get activeFontColor => embroideryColors.firstWhere(
    (c) => c.id == fontColorId,
    orElse: () => embroideryColors.first,
  );

  bool get isSatin => fabricId == 'satin';

  void _goNext() {
    if (step < 2) {
      setState(() {
        step++;
      });
    } else {
      final design = CapDesignData(
        colorId: colorId,
        fabricId: fabricId,
        tasselColorId: tasselColorId,
        topText: topText,
        fontId: fontId,
        fontColorId: fontColorId,
      );

      Get.find<DesignController>().updateCap(design);
      Get.toNamed(Routes.order, arguments: DesignItemType.cap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            DesignAppBar(title: 'تصميم القبعة', onBack: Get.back),
            Expanded(
              child: Column(
                children: [
                  _CapPreview(
                    key: _capPreviewKey,
                    baseColor: activeColor.color,
                    tasselColor: activeTassel.color,
                    fabricId: fabricId,
                    text: topText,
                    textColor: activeFontColor.color,
                    textRotation: _textRotation,
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
                            steps: const ['القماش واللون', 'التزيين', 'تأكيد'],
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
                              label: step < 2 ? 'التالي' : 'إتمام الطلب',
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
              'نوع القماش',
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
              'لون القبعة',
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
                  width: 36,
                  height: 36,
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
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'لون الشرشوبة',
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
            children: tasselColors.map((color) {
              final selected = tasselColorId == color.id;
              return GestureDetector(
                onTap: () => setState(() => tasselColorId = color.id),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.color,
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
        ],
      );
    }

    if (step == 1) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'عبارة التخرج (اختياري)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            textAlign: TextAlign.right,
            decoration: const InputDecoration(hintText: 'مثال: مبروك التخرج'),
            controller: _topTextController,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'لون الخط',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: embroideryColors.map((c) {
                        final selected = fontColorId == c.id;
                        return GestureDetector(
                          onTap: () => setState(() => fontColorId = c.id),
                          child: Container(
                            width: 26,
                            height: 26,
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
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'نوع الخط',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: fontId,
                      items: fontOptions
                          .map(
                            (f) => DropdownMenuItem(
                              value: f.id,
                              child: Text(f.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => fontId = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TextRotateControlsRow(
            title: 'تدوير نص القبعة',
            enabled: topText.isNotEmpty,
            onRotateLeft: () {
              setState(() {
                _textRotation -= 0.15;
              });
              _capPreviewKey.currentState?.updateTextRotation(_textRotation);
            },
            onRotateRight: () {
              setState(() {
                _textRotation += 0.15;
              });
              _capPreviewKey.currentState?.updateTextRotation(_textRotation);
            },
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
                'ملخص الطلب',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 10),
              SummaryRow(
                label: 'القماش',
                value: '$fabricName - ${activeColor.name}',
              ),
              SummaryRow(label: 'الشرشوبة', value: activeTassel.name),
              SummaryRow(label: 'النص', value: topText.isEmpty ? '-' : topText),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Text(
                    '75,000 ل.س',
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'السعر',
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

class _TextRotateControlsRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  const _TextRotateControlsRow({
    required this.title,
    required this.enabled,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 42,
              height: 36,
              child: OutlinedButton(
                onPressed: enabled ? onRotateLeft : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(
                    color: enabled
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(Icons.rotate_left, size: 18, color: iconColor),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 42,
              height: 36,
              child: OutlinedButton(
                onPressed: enabled ? onRotateRight : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(
                    color: enabled
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(Icons.rotate_right, size: 18, color: iconColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CapPreview extends StatefulWidget {
  final Color baseColor;
  final Color tasselColor;
  final String fabricId;
  final String text;
  final Color textColor;
  final double textRotation;

  const _CapPreview({
    Key? key,
    required this.baseColor,
    required this.tasselColor,
    required this.fabricId,
    required this.text,
    required this.textColor,
    this.textRotation = 0,
  }) : super(key: key);

  bool get isSatin => fabricId == 'satin';

  @override
  State<_CapPreview> createState() => _CapPreviewState();
}

class _CapPreviewState extends State<_CapPreview> {
  double _textRotation = 0;

  @override
  void initState() {
    super.initState();
    _textRotation = widget.textRotation;
  }

  @override
  void didUpdateWidget(covariant _CapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textRotation != widget.textRotation) {
      _textRotation = widget.textRotation;
    }
  }

  void updateTextRotation(double value) {
    setState(() {
      _textRotation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.7)
                  ..rotateZ(0.8),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: widget.baseColor,
                    borderRadius: BorderRadius.circular(6),
                    gradient: widget.isSatin
                        ? const LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.white24,
                              Colors.black45,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _textRotation,
                          child: Text(
                            widget.text,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 80,
                child: Column(
                  children: [
                    Container(width: 3, height: 70, color: widget.tasselColor),
                    const SizedBox(height: 2),
                    Container(
                      width: 10,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.tasselColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
