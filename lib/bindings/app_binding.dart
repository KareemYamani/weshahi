import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // UserController متوفر لكل التطبيق
    Get.put(UserController(), permanent: true);
  }
}
