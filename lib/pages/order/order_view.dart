import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weshahi/models/design_and_order_models.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../controllers/user_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user;
    final type = Get.arguments as DesignItemType? ?? DesignItemType.scarf;
    final designCtrl = Get.find<DesignController>();
    final orderCtrl = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(tr('order.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('الاسم: ${user.value.name.isEmpty ? '-' : user.value.name}'),
            const SizedBox(height: 8),
            Text('النوع: ${type == DesignItemType.scarf ? 'وشاح' : 'قبعة'}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                orderCtrl.createOrder(
                  type: type,
                  user: user.value,
                  scarf: type == DesignItemType.scarf
                      ? designCtrl.scarfDesign.value
                      : null,
                  cap: type == DesignItemType.cap
                      ? designCtrl.capDesign.value
                      : null,
                );
                Get.offAllNamed(Routes.success);
              },
              child: Text(tr('order.confirm')),
            ),
          ],
        ),
      ),
    );
  }
}
