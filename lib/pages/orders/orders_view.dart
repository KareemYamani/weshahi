import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../data/design_options.dart';
import '../../models/design_and_order_models.dart';
import '../../theme/app_theme.dart';

import '../../widgets/design_app_bar.dart';

class OrdersScreen extends GetView<OrderController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            DesignAppBar(title: 'طلباتي', onBack: () => Get.back()),
            Expanded(
              child: Obx(() {
                if (controller.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 72,
                          color: AppColors.textSec,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'لا توجد طلبات بعد',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'ابدأ بتصميم وشاحك الخاص الآن!',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSec,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    final isScarf =
                        order.type == DesignItemType.scarf &&
                        order.scarfDesign != null;
                    final color = scarfColors.firstWhere(
                      (c) =>
                          c.id ==
                          (isScarf
                              ? order.scarfDesign!.colorId
                              : order.capDesign!.colorId),
                      orElse: () => scarfColors.first,
                    );

                    final price = isScarf ? '150,000' : '75,000';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color.color,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    isScarf ? '🧣' : '🎓',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      isScarf ? 'وشاح تخرج' : 'قبعة تخرج',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSec,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '$price ل.س',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMain,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '#${order.id}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSec,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
