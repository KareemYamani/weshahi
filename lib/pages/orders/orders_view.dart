import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(tr('orders.title'))),
      body: Obx(() {
        final list = controller.orders;
        if (list.isEmpty) {
          return Center(child: Text(tr('orders.empty')));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) {
            final o = list[i];
            return ListTile(
              title: Text('#${o.id} - ${o.status}'),
              subtitle: Text(o.createdAt.toLocal().toString()),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: list.length,
        );
      }),
    );
  }
}
