import 'package:get/get.dart';
import '../models/design_and_order_models.dart';
import '../models/user_model.dart';

class DesignController extends GetxController {
  final scarfDesign = const ScarfDesignData(
    colorId: 'black',
    fabricId: 'velvet',
    rightText: 'المهندس أحمد',
    leftText: '2025',
    fontId: 'thuluth',
    fontColorId: 'gold',
  ).obs;

  final capDesign = const CapDesignData(
    colorId: 'black',
    fabricId: 'velvet',
    tasselColorId: 'gold',
    topText: 'خريج 2025',
    fontId: 'thuluth',
    fontColorId: 'gold',
  ).obs;

  void updateScarf(ScarfDesignData data) {
    scarfDesign.value = data;
  }

  void updateCap(CapDesignData data) {
    capDesign.value = data;
  }
}

class OrderController extends GetxController {
  final orders = <OrderModel>[].obs;
  final lastOrderId = Rx<int?>(null);

  void createOrder({
    required DesignItemType type,
    required UserModel user,
    ScarfDesignData? scarf,
    CapDesignData? cap,
  }) {
    final id =
        100000 + orders.length + DateTime.now().millisecondsSinceEpoch % 899999;
    final order = OrderModel(
      id: id,
      createdAt: DateTime.now(),
      type: type,
      scarfDesign: scarf,
      capDesign: cap,
      user: user,
      status: 'قيد المراجعة',
    );
    orders.insert(0, order);
    lastOrderId.value = id;
  }
}

