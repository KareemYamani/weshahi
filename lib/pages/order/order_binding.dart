import 'package:get/get.dart';
import '../../controllers/order_and_design_controllers.dart';
import '../../controllers/user_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderController());
    Get.put(UserController(), permanent: true);
  }
}

