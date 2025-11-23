import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderController());
  }
}

