import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DesignCapPage extends StatelessWidget {
  const DesignCapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تصميم القبعة')),
      body: const Center(
        child: Text(
          'تصميم القبعة - قريباً',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
