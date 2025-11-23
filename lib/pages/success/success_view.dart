import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 12),
            Text(tr('success.title')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.home),
              child: Text(tr('common.back_home')),
            ),
          ],
        ),
      ),
    );
  }
}
