import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class SuccessScreen extends GetView<OrderController> {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = controller.lastOrderId.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'تم استلام طلبك بنجاح!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'شكراً لثقتك بنا. سيتم تجهيز طلبك وشحنه قريباً.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSec,
                  ),
                ),
                const SizedBox(height: 8),
                if (id != null)
                  Text(
                    'رقم الطلب: #$id',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSec,
                    ),
                  ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'ماذا سيحدث الآن؟',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• سيقوم فريقنا بمراجعة التصميم.\n'
                        '• قد نتواصل معك لتأكيد بعض التفاصيل.\n'
                        '• مدة التنفيذ المتوقعة: 3-5 أيام عمل.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'تتبع طلبي',
                  onPressed: () {
                    Get.offAllNamed(Routes.orders);
                  },
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
