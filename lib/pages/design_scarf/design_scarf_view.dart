import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DesignScarfPage extends StatelessWidget {
  const DesignScarfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تصميم الوشاح')),
      body: const Center(
        child: Text(
          'تصميم الوشاح - قريباً',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
