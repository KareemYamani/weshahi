import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/order_and_design_controllers.dart';
import '../services/prefs.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final userCtrl = Get.put(UserController(), permanent: true);
    Get.put(DesignController(), permanent: true);
    Get.put(OrderController(), permanent: true);

    // Attempt to preload user from local storage (non-blocking)
    Prefs.loadUser().then((u) {
      if (u != null) userCtrl.setUser(u);
    });
  }
}
