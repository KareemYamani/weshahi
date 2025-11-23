import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/order_and_design_controllers.dart';
import '../controllers/profile_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/user_info_controller.dart';
import '../routes/app_routes.dart';
import '../pages/splash/splash_view.dart';
import '../pages/onboarding/onboarding_view.dart';
import '../pages/user_info/user_info_view.dart';
import '../pages/home/home_view.dart';
import '../pages/profile/profile_view.dart';
import '../pages/orders/orders_view.dart';
import '../pages/order/order_view.dart';
import '../pages/success/success_view.dart';
import '../pages/design_scarf/design_scarf_view.dart';
import '../pages/design_cap/design_cap_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.userInfo,
      page: () => const UserInfoScreen(),
      binding: BindingsBuilder(() {
        Get.put(UserInfoController());
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.put(DesignController(), permanent: true);
        Get.put(OrderController(), permanent: true);
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.designScarf,
      page: () => const ScarfDesignScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.designCap,
      page: () => const CapDesignScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.order,
      page: () => const OrderScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.success,
      page: () => const SuccessScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];
}
