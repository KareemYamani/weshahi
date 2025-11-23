import 'package:get/get.dart';
import '../routes/app_routes.dart';

import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';

import '../pages/onboarding/onboarding_binding.dart';
import '../pages/onboarding/onboarding_view.dart';

import '../pages/user_info/user_info_binding.dart';
import '../pages/user_info/user_info_view.dart';

import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';

import '../pages/profile/profile_binding.dart';
import '../pages/profile/profile_view.dart';

import '../pages/orders/orders_binding.dart';
import '../pages/orders/orders_view.dart';

import '../pages/order/order_binding.dart';
import '../pages/order/order_view.dart';

import '../pages/success/success_binding.dart';
import '../pages/success/success_view.dart';
import '../pages/language/language_binding.dart';
import '../pages/language/language_view.dart';

import '../pages/design_scarf/design_scarf_binding.dart';
import '../pages/design_scarf/design_scarf_view.dart';
import '../pages/design_cap/design_cap_binding.dart';
import '../pages/design_cap/design_cap_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.language,
      page: () => const LanguageSelectPage(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.userInfo,
      page: () => const UserInfoPage(),
      binding: UserInfoBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersPage(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: Routes.order,
      page: () => const OrderPage(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: Routes.success,
      page: () => const SuccessPage(),
      binding: SuccessBinding(),
    ),
    GetPage(
      name: Routes.designScarf,
      page: () => const DesignScarfPage(),
      binding: DesignScarfBinding(),
    ),
    GetPage(
      name: Routes.designCap,
      page: () => const DesignCapPage(),
      binding: DesignCapBinding(),
    ),
  ];
}
