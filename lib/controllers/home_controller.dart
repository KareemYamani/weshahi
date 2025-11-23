import 'package:get/get.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final bottomIndex = 0.obs;

  void changeTab(int index) {
    bottomIndex.value = index;

    if (index == 0) {
      Get.offAllNamed(Routes.home);
    } else if (index == 1) {
      Get.toNamed(Routes.designScarf);
    } else if (index == 2) {
      Get.toNamed(Routes.orders);
    }
  }
}
