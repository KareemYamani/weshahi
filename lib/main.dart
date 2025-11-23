// =======================================
// lib/main.dart
// =======================================
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeshahiApp());
}

class WeshahiApp extends StatelessWidget {
  const WeshahiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'وشاحي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

// =======================================
// lib/bindings/app_binding.dart
// =======================================

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // UserController متوفر لكل التطبيق
    Get.put(UserController(), permanent: true);
  }
}

// =======================================
// lib/routes/app_routes.dart
// =======================================
abstract class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const userInfo = '/user-info';
  static const home = '/home';
  static const profile = '/profile';
  static const designScarf = '/design-scarf';
  static const designCap = '/design-cap';
  static const order = '/order';
  static const success = '/success';
  static const orders = '/orders';
}

// =======================================
// lib/routes/app_pages.dart
// =======================================

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

// =======================================
// lib/theme/app_theme.dart
// =======================================

class AppColors {
  static const Color primary = Color(0xFF020617); // slate-900
  static const Color accent = Color(0xFFEAB308); // amber-500
  static const Color accentDark = Color(0xFFCA8A04); // amber-600
  static const Color bg = Color(0xFFF8FAFC); // slate-50
  static const Color textMain = Color(0xFF020617);
  static const Color textSec = Color(0xFF64748B);
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        base.textTheme,
      ).apply(bodyColor: AppColors.textMain, displayColor: AppColors.textMain),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textMain),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accentDark, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// =======================================
// lib/models/user_model.dart
// =======================================
class UserModel {
  final String name;
  final String phone;
  final String city;
  final String address;

  const UserModel({
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
  });

  UserModel copyWith({
    String? name,
    String? phone,
    String? city,
    String? address,
  }) {
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }

  static const empty = UserModel(
    name: '',
    phone: '',
    city: 'دمشق',
    address: '',
  );
}

// =======================================
// lib/models/product_model.dart
// =======================================

class ProductModel {
  final int id;
  final String name;
  final String price;
  final String emoji;
  final Color color;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.color,
    required this.category,
  });
}

// =======================================
// lib/data/app_data.dart
// =======================================

const List<String> syriaCities = [
  'دمشق',
  'ريف دمشق',
  'حلب',
  'حمص',
  'اللاذقية',
  'طرطوس',
  'حماة',
  'درعا',
  'السويداء',
  'دير الزور',
  'الحسكة',
  'الرقة',
  'إدلب',
  'القنيطرة',
];

const List<ProductModel> products = [
  ProductModel(
    id: 1,
    name: 'وشاح الفخامة الملكي',
    price: '150,000',
    emoji: '🎓',
    color: Color(0xFF020617), // slate-900
    category: 'men',
  ),
  ProductModel(
    id: 2,
    name: 'وشاح النخبة المخملي',
    price: '125,000',
    emoji: '✨',
    color: Color(0xFF7F1D1D), // red-900
    category: 'women',
  ),
  ProductModel(
    id: 3,
    name: 'وشاح التميز الذهبي',
    price: '140,000',
    emoji: '👑',
    color: Color(0xFF334155), // slate-700
    category: 'custom',
  ),
  ProductModel(
    id: 4,
    name: 'وشاح المستقبل',
    price: '130,000',
    emoji: '🚀',
    color: Color(0xFF0F172A), // blue-ish slate
    category: 'men',
  ),
];

// =======================================
// lib/models/design_and_order_models.dart
// =======================================

enum DesignItemType { scarf, cap }

class ScarfColor {
  final String id;
  final String name;
  final Color color;

  const ScarfColor({required this.id, required this.name, required this.color});
}

class TasselColor {
  final String id;
  final String name;
  final Color color;

  const TasselColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

class EmbroideryColor {
  final String id;
  final String name;
  final Color color;

  const EmbroideryColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

class ArabicFontOption {
  final String id;
  final String name;

  const ArabicFontOption({required this.id, required this.name});
}

class FabricOption {
  final String id;
  final String name;
  final String description;

  const FabricOption({
    required this.id,
    required this.name,
    required this.description,
  });
}

class ScarfDesignData {
  final String colorId;
  final String fabricId;
  final String rightText;
  final String leftText;
  final String fontId;
  final String fontColorId;

  const ScarfDesignData({
    required this.colorId,
    required this.fabricId,
    required this.rightText,
    required this.leftText,
    required this.fontId,
    required this.fontColorId,
  });
}

class CapDesignData {
  final String colorId;
  final String fabricId;
  final String tasselColorId;
  final String topText;
  final String fontId;
  final String fontColorId;

  const CapDesignData({
    required this.colorId,
    required this.fabricId,
    required this.tasselColorId,
    required this.topText,
    required this.fontId,
    required this.fontColorId,
  });
}

class OrderModel {
  final int id;
  final DateTime createdAt;
  final DesignItemType type;
  final ScarfDesignData? scarfDesign;
  final CapDesignData? capDesign;
  final UserModel user;
  final String status;

  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.scarfDesign,
    required this.capDesign,
    required this.user,
    required this.status,
  });
}

// =======================================
// lib/data/design_options.dart
// =======================================

const List<ScarfColor> scarfColors = [
  ScarfColor(id: 'navy', name: 'كحلي ملكي', color: Color(0xFF0F172A)),
  ScarfColor(id: 'maroon', name: 'عنابي فاخر', color: Color(0xFF7F1D1D)),
  ScarfColor(id: 'black', name: 'أسود ليلي', color: Color(0xFF020617)),
  ScarfColor(id: 'emerald', name: 'زمردي', color: Color(0xFF064E3B)),
  ScarfColor(id: 'white', name: 'أبيض نقي', color: Color(0xFFF1F5F9)),
];

const List<TasselColor> tasselColors = [
  TasselColor(id: 'gold', name: 'ذهبي', color: Color(0xFFFBBF24)),
  TasselColor(id: 'black', name: 'أسود', color: Color(0xFF000000)),
  TasselColor(id: 'blue', name: 'أزرق', color: Color(0xFF1D4ED8)),
  TasselColor(id: 'red', name: 'أحمر', color: Color(0xFFB91C1C)),
  TasselColor(id: 'white', name: 'أبيض', color: Color(0xFFFFFFFF)),
];

const List<EmbroideryColor> embroideryColors = [
  EmbroideryColor(id: 'gold', name: 'ذهبي لامع', color: Color(0xFFFBBF24)),
  EmbroideryColor(id: 'silver', name: 'فضي', color: Color(0xFFCBD5E1)),
  EmbroideryColor(id: 'white', name: 'أبيض', color: Color(0xFFFFFFFF)),
  EmbroideryColor(id: 'black', name: 'أسود', color: Color(0xFF000000)),
];

const List<ArabicFontOption> fontOptions = [
  ArabicFontOption(id: 'thuluth', name: 'خط الثلث'),
  ArabicFontOption(id: 'kufi', name: 'كوفي هندسي'),
  ArabicFontOption(id: 'diwani', name: 'ديواني مزخرف'),
];

const List<FabricOption> fabricOptions = [
  FabricOption(id: 'velvet', name: 'مخمل', description: 'فخم، دافئ، غير لامع'),
  FabricOption(id: 'satin', name: 'ساتان', description: 'ناعم، لامع، انسيابي'),
];

// =======================================
// lib/controllers/user_controller.dart
// =======================================

class UserController extends GetxController {
  final user = UserModel.empty.obs;

  void setUser(UserModel newUser) {
    user.value = newUser;
  }

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
  }
}

// =======================================
// lib/controllers/splash_controller.dart
// =======================================

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController logoController;
  late final Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scaleAnimation = CurvedAnimation(
      parent: logoController,
      curve: Curves.easeOutBack,
    );

    logoController.forward();

    Timer(const Duration(milliseconds: 2300), () {
      Get.offAllNamed(Routes.onboarding);
    });
  }

  @override
  void onClose() {
    logoController.dispose();
    super.onClose();
  }
}

// =======================================
// lib/controllers/onboarding_controller.dart
// =======================================

class OnboardingSlide {
  final String title;
  final String desc;
  final String icon;

  OnboardingSlide({
    required this.title,
    required this.desc,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  final slides = <OnboardingSlide>[
    OnboardingSlide(
      title: 'فخامة تليق بإنجازك',
      desc: 'تشكيلة حصرية من أوشحة التخرج المصممة بأجود أنواع المخمل.',
      icon: '🎓',
    ),
    OnboardingSlide(
      title: 'صمم وشاحك بنفسك',
      desc: 'اختر اللون، الخط، والنص. وشاهد النتيجة مباشرة قبل الطلب.',
      icon: '✨',
    ),
    OnboardingSlide(
      title: 'توصيل لجميع المحافظات',
      desc: 'اطلب الآن وادفع عند الاستلام في سوريا.',
      icon: '🚀',
    ),
  ].obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void next() {
    if (currentIndex.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      Get.offAllNamed(Routes.userInfo);
    }
  }

  bool get isLast => currentIndex.value == slides.length - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// =======================================
// lib/controllers/user_info_controller.dart
// =======================================

class UserInfoController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  final selectedCity = 'دمشق'.obs;
  final error = ''.obs;

  List<String> get cities => syriaCities;

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<UserController>().user.value;

    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    addressController = TextEditingController(text: user.address);
    selectedCity.value = user.city;
  }

  void submit() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      error.value = 'يرجى تعبئة جميع الحقول المطلوبة';
      return;
    }

    if (!RegExp(r'^09\d{8}$').hasMatch(phone)) {
      error.value = 'رقم الجوال يجب أن يبدأ بـ 09 ويتكون من 10 أرقام';
      return;
    }

    error.value = '';
    final user = UserModel(
      name: name,
      phone: phone,
      city: selectedCity.value,
      address: address,
    );

    Get.find<UserController>().setUser(user);
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

// =======================================
// lib/controllers/home_controller.dart
// =======================================

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

// =======================================
// lib/controllers/order_and_design_controllers.dart
// =======================================

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

// =======================================
// lib/controllers/profile_controller.dart
// =======================================

class ProfileController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  final selectedCity = 'دمشق'.obs;
  final isSaved = false.obs;
  final avatarLetter = 'U'.obs;

  List<String> get cities => syriaCities;

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<UserController>().user.value;

    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    addressController = TextEditingController(text: user.address);
    selectedCity.value = user.city;

    _updateAvatarLetter();
    nameController.addListener(_updateAvatarLetter);
  }

  void save() {
    final updatedUser = UserModel(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: selectedCity.value,
      address: addressController.text.trim(),
    );

    Get.find<UserController>().updateUser(updatedUser);
    isSaved.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isSaved.value = false;
    });

    Get.snackbar(
      'تم الحفظ',
      'تم تحديث بيانات ملفك الشخصي بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
    );
  }

  void _updateAvatarLetter() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      avatarLetter.value = 'U';
    } else {
      avatarLetter.value = name.characters.first.toUpperCase();
    }
  }

  @override
  void onClose() {
    nameController.removeListener(_updateAvatarLetter);
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

// =======================================
// lib/widgets/primary_button.dart
// =======================================

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool isLight;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isLight ? Colors.white : AppColors.primary;
    final fgColor = isLight ? AppColors.primary : Colors.white;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.18),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// =======================================
// lib/widgets/product_card.dart
// =======================================

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: product.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.9, end: 1),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: Text(
                            product.emoji,
                            style: const TextStyle(
                              fontSize: 42,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${product.price} ',
                      style: const TextStyle(
                        color: AppColors.accentDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const Text(
                      'ل.س',
                      style: TextStyle(color: AppColors.textSec, fontSize: 9),
                    ),
                    const Spacer(),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================
// lib/widgets/bottom_nav_bar.dart
// =======================================

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 18, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.12))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_filled,
            label: 'الرئيسية',
            isActive: currentIndex == 0,
            onTap: () => onChanged(0),
          ),
          SizedBox(
            height: 62,
            width: 62,
            child: GestureDetector(
              onTap: () => onChanged(1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: AppColors.accent,
                  size: 26,
                ),
              ),
            ),
          ),
          _NavItem(
            icon: Icons.shopping_bag_outlined,
            label: 'طلباتي',
            isActive: currentIndex == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSec;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================
// lib/screens/splash_screen.dart
// =======================================

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.12),
                  width: 30,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: controller.scaleAnimation,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFACC15), Color(0xFFCA8A04)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.32),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'W',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'وشاحي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'LUXURY GRADUATION',
                  style: TextStyle(
                    color: AppColors.accent.withOpacity(0.8),
                    fontSize: 10,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================
// lib/screens/onboarding_screen.dart
// =======================================

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.slides.length,
                  itemBuilder: (context, index) {
                    final slide = controller.slides[index];
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        key: ValueKey(slide.title),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Text(
                              slide.icon,
                              style: const TextStyle(
                                fontSize: 90,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 14,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 260,
                            child: Text(
                              slide.desc,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.6,
                                color: AppColors.textSec,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: controller.currentIndex.value == i ? 22 : 7,
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == i
                            ? AppColors.accent
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Obx(
                () => PrimaryButton(
                  label: controller.isLast ? 'ابدأ الآن' : 'التالي',
                  onPressed: controller.next,
                  icon: Icon(
                    controller.isLast
                        ? Icons.check_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================
// lib/screens/user_info_screen.dart
// =======================================

class UserInfoScreen extends GetView<UserInfoController> {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mediaQuery = MediaQuery.of(context);
          final contentHeight =
              constraints.maxHeight - mediaQuery.padding.vertical;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: contentHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 32,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'لنتعرّف عليك',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const SizedBox(
                              width: 280,
                              child: Text(
                                'يرجى إدخال بياناتك لتسهيل عملية التوصيل داخل سوريا.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSec,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controller.nameController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            labelText: 'الاسم الكامل',
                            hintText: 'الاسم الثلاثي',
                          ),
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'رقم الجوال',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            textDirection: TextDirection.ltr,
                            children: [
                              Container(
                                width: 70,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+963',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextFormField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.left,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      hintText: '9xxxxxxxx',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'المحافظة والعنوان',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                height: 52,
                                child: Obx(
                                  () => DropdownButtonFormField<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    value: controller.selectedCity.value,
                                    items: controller.cities
                                        .map(
                                          (c) => DropdownMenuItem(
                                            value: c,
                                            child: Text(
                                              c,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedCity.value = value;
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: AppColors.textSec,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'المحافظة',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 7,
                              child: TextField(
                                controller: controller.addressController,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  labelText: 'العنوان',
                                  hintText: 'المنطقة، الشارع...',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => controller.error.value.isEmpty
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFB91C1C),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          controller.error.value,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFB91C1C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 40),
                        PrimaryButton(
                          label: 'حفظ ومتابعة',
                          onPressed: controller.submit,
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =======================================
// lib/screens/home_screen.dart
// =======================================

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _Header(user: user.value),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroSection(),
                        const SizedBox(height: 10),
                        _ActionsSection(),
                        const SizedBox(height: 14),
                        _ProductsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: BottomNavBar(
                  currentIndex: controller.bottomIndex.value,
                  onChanged: (index) {
                    controller.changeTab(index);
                    // الآن فقط واجهة - ممكن تربط لاحقاً بصفحات إضافية
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic user;
  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    final city = (user.city as String?) ?? 'دمشق';
    final name = (user.name as String?) ?? 'خريج مميز';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.profile),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE2E8F0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.isEmpty ? 'U' : name.characters.first,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مرحباً بك 👋',
                      style: TextStyle(fontSize: 11, color: AppColors.textSec),
                    ),
                    SizedBox(
                      width: 130,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 10,
                            color: AppColors.accentDark,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            city,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.accentDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textSec,
                  size: 22,
                ),
              ),
              Positioned(
                right: 9,
                top: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 18, bottom: 4),
      child: _FadeInFromBottom(
        beginOffset: 26,
        duration: const Duration(milliseconds: 650),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
            gradient: const LinearGradient(
              colors: [Color(0xFF020617), Color(0xFF0F172A)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.12,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 130,
                      color: Colors.white.withOpacity(0.45),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: _SeasonChip(),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'تألّق في يوم تخرجك\nمع وشاحي',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.3,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'جودة لا تضاهى وتصاميم عصرية تناسب طموحك.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFFCBD5F5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.9, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: const Text(
                        '🎓',
                        style: TextStyle(
                          fontSize: 80,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ماذا تود أن تصمّم اليوم؟',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.designScarf),
                  child: _FadeInFromBottom(
                    beginOffset: 20,
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            left: -10,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF020617),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.palette_outlined,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const Text(
                                      'الأكثر طلباً',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'تصميم\nوشاح',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const Positioned(
                            bottom: -14,
                            right: -8,
                            child: Text(
                              '🧣',
                              style: TextStyle(
                                fontSize: 54,
                                color: Colors.white24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.designCap),
                  child: _FadeInFromBottom(
                    beginOffset: 24,
                    duration: const Duration(milliseconds: 680),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            left: -10,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.school_rounded,
                                        color: AppColors.accentDark.withOpacity(
                                          0.7,
                                        ),
                                        size: 22,
                                      ),
                                    ),
                                    const Text(
                                      'جديد وحصري',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSec,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'تصميم\nقبعة',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textMain,
                                    fontSize: 16,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const Positioned(
                            bottom: -10,
                            right: -6,
                            child: Text(
                              '🎓',
                              style: TextStyle(
                                fontSize: 54,
                                color: Color(0xFFFACC15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // لاحقاً يمكن ربطها بمعرض تصاميم حقيقي
            },
            child: _FadeInFromBottom(
              beginOffset: 22,
              duration: const Duration(milliseconds: 720),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentDark],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.18,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.auto_awesome_mosaic,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'معرض الإلهام',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      'شاهد تصاميم الخريجين السابقين واستلهم فكرتك',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'أحدث الموديلات',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'جاهزة للطلب',
                  style: TextStyle(fontSize: 9, color: AppColors.textSec),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  // ممكن لاحقاً تربطها بصفحة تفاصيل المنتج
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// =======================================
// lib/screens/profile_screen.dart
// =======================================

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _ProfileAppBar(),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            _AvatarSection(),
                            const SizedBox(height: 18),
                            _FormSection(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _BottomSaveButton(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SeasonChip extends StatelessWidget {
  const _SeasonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'موسم التخرج 2025',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FadeInFromBottom extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double beginOffset;

  const _FadeInFromBottom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.beginOffset = 20,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginOffset, end: 0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final opacity = (beginOffset - value) / beginOffset;
        return Opacity(
          opacity: opacity.clamp(0, 1),
          child: Transform.translate(offset: Offset(0, value), child: child),
        );
      },
      child: child,
    );
  }
}

// =======================================
// lib/screens/design_and_order_screens.dart
// =======================================

class ScarfDesignScreen extends StatefulWidget {
  const ScarfDesignScreen({super.key});

  @override
  State<ScarfDesignScreen> createState() => _ScarfDesignScreenState();
}

class _ScarfDesignScreenState extends State<ScarfDesignScreen> {
  int step = 0;

  String colorId = 'black';
  String fabricId = 'velvet';
  String rightText = 'المهندس أحمد';
  String leftText = '2025';
  String fontId = 'thuluth';
  String fontColorId = 'gold';

  late final TextEditingController _rightTextController;
  late final TextEditingController _leftTextController;

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _rightLogoBytes;
  Uint8List? _leftLogoBytes;
  final GlobalKey<_ScarfSideState> _rightScarfKey = GlobalKey<_ScarfSideState>();
  final GlobalKey<_ScarfSideState> _leftScarfKey = GlobalKey<_ScarfSideState>();

  @override
  void initState() {
    super.initState();
    _rightTextController = TextEditingController(text: rightText);
    _leftTextController = TextEditingController(text: leftText);

    _rightTextController.addListener(() {
      setState(() {
        rightText = _rightTextController.text;
      });
    });
    _leftTextController.addListener(() {
      setState(() {
        leftText = _leftTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _rightTextController.dispose();
    _leftTextController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo({required bool isRightSide}) async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      setState(() {
        if (isRightSide) {
          _rightLogoBytes = bytes;
        } else {
          _leftLogoBytes = bytes;
        }
      });
    } catch (e) {
      Get.snackbar(
        'خطأ في اختيار الصورة',
        'تعذر تحميل الشعار، يرجى المحاولة لاحقاً.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  ScarfColor get activeColor => scarfColors.firstWhere(
    (c) => c.id == colorId,
    orElse: () => scarfColors.first,
  );

  EmbroideryColor get activeFontColor => embroideryColors.firstWhere(
    (c) => c.id == fontColorId,
    orElse: () => embroideryColors.first,
  );

  ArabicFontOption get activeFont => fontOptions.firstWhere(
    (f) => f.id == fontId,
    orElse: () => fontOptions.first,
  );

  bool get isSatin => fabricId == 'satin';

  double _fontSizeFor(String text) {
    const base = 22.0;
    if (text.isEmpty) return base;
    if (text.length <= 6) return base;
    final reduced = base - (text.length - 6) * 0.8;
    return reduced.clamp(12.0, base);
  }

  void _goNext() {
    if (step < 3) {
      setState(() {
        step++;
      });
    } else {
      final design = ScarfDesignData(
        colorId: colorId,
        fabricId: fabricId,
        rightText: rightText,
        leftText: leftText,
        fontId: fontId,
        fontColorId: fontColorId,
      );

      Get.find<DesignController>().updateScarf(design);
      Get.toNamed(Routes.order, arguments: DesignItemType.scarf);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _DesignAppBar(title: 'استوديو التصميم', onBack: Get.back),
            Expanded(
              child: Column(
                children: [
                  _ScarfPreview(
                    color: activeColor.color,
                    fabricId: fabricId,
                    rightText: rightText,
                    leftText: leftText,
                    fontColor: activeFontColor.color,
                    fontSizeRight: _fontSizeFor(rightText),
                    fontSizeLeft: _fontSizeFor(leftText),
                    rightLogoBytes: _rightLogoBytes,
                    leftLogoBytes: _leftLogoBytes,
                    rightKey: _rightScarfKey,
                    leftKey: _leftScarfKey,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 20,
                            offset: Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _StepsHeader(
                            steps: const [
                              'القماش واللون',
                              'النص',
                              'الشعارات',
                              'تأكيد',
                            ],
                            current: step,
                            onTap: (i) => setState(() => step = i),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _buildStepContent(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: PrimaryButton(
                              label: step < 3 ? 'التالي' : 'إتمام الطلب',
                              onPressed: _goNext,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (step == 0) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اختر نوع القماش',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: fabricOptions.map((fabric) {
              final selected = fabricId == fabric.id;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => fabricId = fabric.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          fabric.name,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.textMain,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fabric.description,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: selected
                                ? Colors.white70
                                : AppColors.textSec,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اختر لون الوشاح',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: scarfColors.map((color) {
              final selected = colorId == color.id;
              return GestureDetector(
                onTap: () => setState(() => colorId = color.id),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.6),
                      width: selected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (step == 1) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الطرف الأيمن',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'مثال: المهندس أحمد',
                      ),
                      controller: _rightTextController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الطرف الأيسر',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'مثال: دفعة 2025',
                      ),
                      controller: _leftTextController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'لون خيوط التطريز',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: embroideryColors.map((c) {
              final selected = fontColorId == c.id;
              return GestureDetector(
                onTap: () => setState(() => fontColorId = c.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'نوع الخط العربي',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: fontOptions.map((f) {
              final selected = fontId == f.id;
              return ChoiceChip(
                label: Text(f.name),
                selected: selected,
                onSelected: (_) => setState(() => fontId = f.id),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (step == 2) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          _LogoUploadTile(
            title: 'شعار الطرف الأيمن',
            subtitle: 'اضغط للرفع',
            bytes: _rightLogoBytes,
            onPick: () => _pickLogo(isRightSide: true),
            onRemove: _rightLogoBytes == null
                ? null
                : () {
                    setState(() {
                      _rightLogoBytes = null;
                    });
                  },
          ),
          const SizedBox(height: 12),
          _LogoUploadTile(
            title: 'شعار الطرف الأيسر',
            subtitle: 'اضغط للرفع',
            bytes: _leftLogoBytes,
            onPick: () => _pickLogo(isRightSide: false),
            onRemove: _leftLogoBytes == null
                ? null
                : () {
                    setState(() {
                      _leftLogoBytes = null;
                    });
                  },
          ),
          const SizedBox(height: 16),
          _LogoControlsRow(
            title: 'تحكم شعار الطرف الأيمن',
            enabled: _rightLogoBytes != null,
            onZoomIn: () => _rightScarfKey.currentState?.adjustScale(0.1),
            onZoomOut: () => _rightScarfKey.currentState?.adjustScale(-0.1),
            onRotateLeft: () => _rightScarfKey.currentState?.adjustRotation(-0.15),
            onRotateRight: () => _rightScarfKey.currentState?.adjustRotation(0.15),
          ),
          const SizedBox(height: 8),
          _LogoControlsRow(
            title: 'تحكم شعار الطرف الأيسر',
            enabled: _leftLogoBytes != null,
            onZoomIn: () => _leftScarfKey.currentState?.adjustScale(0.1),
            onZoomOut: () => _leftScarfKey.currentState?.adjustScale(-0.1),
            onRotateLeft: () => _leftScarfKey.currentState?.adjustRotation(-0.15),
            onRotateRight: () => _leftScarfKey.currentState?.adjustRotation(0.15),
          ),
          const SizedBox(height: 16),
          const Text(
            'يمكنك سحب الشعارات وتكبيرها وتدويرها مباشرة من منطقة المعاينة في الأعلى.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSec),
          ),
        ],
      );
    }

    final fabricName = fabricOptions
        .firstWhere((f) => f.id == fabricId, orElse: () => fabricOptions.first)
        .name;

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ملخص التصميم',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 10),
              _SummaryRow(label: 'القماش', value: fabricName),
              _SummaryRow(label: 'اللون', value: activeColor.name),
              _SummaryRow(label: 'النص', value: '$rightText / $leftText'),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Text(
                    '150,000 ل.س',
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'السعر النهائي',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScarfPreview extends StatelessWidget {
  final Color color;
  final String fabricId;
  final String rightText;
  final String leftText;
  final Color fontColor;
  final double fontSizeRight;
  final double fontSizeLeft;
  final Uint8List? rightLogoBytes;
  final Uint8List? leftLogoBytes;
  final GlobalKey<_ScarfSideState>? rightKey;
  final GlobalKey<_ScarfSideState>? leftKey;

  const _ScarfPreview({
    required this.color,
    required this.fabricId,
    required this.rightText,
    required this.leftText,
    required this.fontColor,
    required this.fontSizeRight,
    required this.fontSizeLeft,
    this.rightLogoBytes,
    this.leftLogoBytes,
    this.rightKey,
    this.leftKey,
  });

  bool get isSatin => fabricId == 'satin';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFFE5E7EB)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScarfSide(
              key: rightKey,
              color: color,
              isSatin: isSatin,
              text: rightText,
              fontColor: fontColor,
              fontSize: fontSizeRight,
              rotateRight: true,
              logoBytes: rightLogoBytes,
            ),
            const SizedBox(width: 14),
            _ScarfSide(
              key: leftKey,
              color: color,
              isSatin: isSatin,
              text: leftText,
              fontColor: fontColor,
              fontSize: fontSizeLeft,
              rotateRight: false,
              logoBytes: leftLogoBytes,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScarfSide extends StatefulWidget {
  final Color color;
  final bool isSatin;
  final String text;
  final Color fontColor;
  final double fontSize;
  final bool rotateRight;
  final Uint8List? logoBytes;

  const _ScarfSide({
    Key? key,
    required this.color,
    required this.isSatin,
    required this.text,
    required this.fontColor,
    required this.fontSize,
    required this.rotateRight,
    this.logoBytes,
  }) : super(key: key);

  @override
  State<_ScarfSide> createState() => _ScarfSideState();
}

class _ScarfSideState extends State<_ScarfSide> {
  Offset _logoOffset = Offset.zero;
  double _logoScale = 1;
  double _logoRotation = 0;
  Offset _textOffset = Offset.zero;

  late Offset _startFocalPoint;
  late Offset _startOffset;
  late double _startScale;
  late double _startRotation;

  @override
  void didUpdateWidget(covariant _ScarfSide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logoBytes != widget.logoBytes && widget.logoBytes != null) {
      // Reset transform when a new logo is added.
      _logoOffset = Offset.zero;
      _logoScale = 1;
      _logoRotation = 0;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startFocalPoint = details.focalPoint;
    _startOffset = _logoOffset;
    _startScale = _logoScale;
    _startRotation = _logoRotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final delta = details.focalPoint - _startFocalPoint;
    setState(() {
      _logoOffset = _clampOffset(_startOffset + delta);
      _logoScale = (_startScale * details.scale).clamp(0.6, 2.4);
      _logoRotation = _startRotation + details.rotation;
    });
  }

  void adjustScale(double delta) {
    setState(() {
      _logoScale = (_logoScale + delta).clamp(0.6, 2.4);
    });
  }

  void adjustRotation(double delta) {
    setState(() {
      _logoRotation += delta;
    });
  }

  Offset _clampOffset(Offset offset) {
    const dxLimit = 18.0;
    const dyLimit = 60.0;
    return Offset(
      offset.dx.clamp(-dxLimit, dxLimit),
      offset.dy.clamp(-dyLimit, dyLimit),
    );
  }

  Offset _clampTextOffset(Offset offset) {
    const dxLimit = 20.0;
    const dyLimit = 70.0;
    return Offset(
      offset.dx.clamp(-dxLimit, dxLimit),
      offset.dy.clamp(-dyLimit, dyLimit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 210,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
        gradient: widget.isSatin
            ? const LinearGradient(
                colors: [Colors.black54, Colors.white24, Colors.black45],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Transform.translate(
                offset: _textOffset,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _textOffset =
                          _clampTextOffset(_textOffset + details.delta);
                    });
                  },
                  child: Transform.rotate(
                    angle: widget.rotateRight ? -3.14 / 2 : 3.14 / 2,
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: widget.fontColor,
                        fontWeight: FontWeight.w800,
                        fontSize: widget.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.logoBytes != null)
            Positioned.fill(
              child: Center(
                child: Transform.translate(
                  offset: _logoOffset,
                  child: GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    child: Transform.rotate(
                      angle: _logoRotation,
                      child: Transform.scale(
                        scale: _logoScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            widget.logoBytes!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 6,
            left: 26,
            right: 26,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoUploadTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? bytes;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  const _LogoUploadTile({
    required this.title,
    required this.subtitle,
    required this.bytes,
    required this.onPick,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = bytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPick,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                if (hasLogo) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      bytes!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else ...[
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.textSec,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        hasLogo ? 'تم إضافة الشعار، اضغط لتغييره' : subtitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'يُفضل شعار شفاف (PNG)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLogo && onRemove != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoControlsRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  const _LogoControlsRow({
    required this.title,
    required this.enabled,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRotateLeft,
    required this.onRotateRight,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        enabled ? AppColors.primary : AppColors.textSec.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildControlButton(
              icon: Icons.zoom_out,
              color: iconColor,
              enabled: enabled,
              onTap: onZoomOut,
            ),
            _buildControlButton(
              icon: Icons.zoom_in,
              color: iconColor,
              enabled: enabled,
              onTap: onZoomIn,
            ),
            _buildControlButton(
              icon: Icons.rotate_left,
              color: iconColor,
              enabled: enabled,
              onTap: onRotateLeft,
            ),
            _buildControlButton(
              icon: Icons.rotate_right,
              color: iconColor,
              enabled: enabled,
              onTap: onRotateRight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 42,
      height: 36,
      child: OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: enabled ? const Color(0xFFE2E8F0) : const Color(0xFFE5E7EB),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }
}

class _TextRotateControlsRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;

  const _TextRotateControlsRow({
    required this.title,
    required this.enabled,
    required this.onRotateLeft,
    required this.onRotateRight,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        enabled ? AppColors.primary : AppColors.textSec.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 42,
              height: 36,
              child: OutlinedButton(
                onPressed: enabled ? onRotateLeft : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(
                    color: enabled
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(
                  Icons.rotate_left,
                  size: 18,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 42,
              height: 36,
              child: OutlinedButton(
                onPressed: enabled ? onRotateRight : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(
                    color: enabled
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(
                  Icons.rotate_right,
                  size: 18,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _DesignAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _DesignAppBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _StepsHeader extends StatelessWidget {
  final List<String> steps;
  final int current;
  final ValueChanged<int> onTap;

  const _StepsHeader({
    required this.steps,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: List.generate(steps.length, (i) {
                final isActive = i == current;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => onTap(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        steps[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : AppColors.textSec,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSec),
          ),
        ],
      ),
    );
  }
}

class CapDesignScreen extends StatefulWidget {
  const CapDesignScreen({super.key});

  @override
  State<CapDesignScreen> createState() => _CapDesignScreenState();
}

class _CapDesignScreenState extends State<CapDesignScreen> {
  int step = 0;

  String colorId = 'black';
  String fabricId = 'velvet';
  String tasselColorId = 'gold';
  String topText = 'خريج 2025';
  String fontId = 'thuluth';
  String fontColorId = 'gold';
  double _textRotation = 0;

  final GlobalKey<_CapPreviewState> _capPreviewKey =
      GlobalKey<_CapPreviewState>();

  late final TextEditingController _topTextController;

  @override
  void initState() {
    super.initState();
    _topTextController = TextEditingController(text: topText);
    _topTextController.addListener(() {
      setState(() {
        topText = _topTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _topTextController.dispose();
    super.dispose();
  }

  ScarfColor get activeColor => scarfColors.firstWhere(
    (c) => c.id == colorId,
    orElse: () => scarfColors.first,
  );

  TasselColor get activeTassel => tasselColors.firstWhere(
    (c) => c.id == tasselColorId,
    orElse: () => tasselColors.first,
  );

  EmbroideryColor get activeFontColor => embroideryColors.firstWhere(
    (c) => c.id == fontColorId,
    orElse: () => embroideryColors.first,
  );

  bool get isSatin => fabricId == 'satin';

  void _goNext() {
    if (step < 2) {
      setState(() {
        step++;
      });
    } else {
      final design = CapDesignData(
        colorId: colorId,
        fabricId: fabricId,
        tasselColorId: tasselColorId,
        topText: topText,
        fontId: fontId,
        fontColorId: fontColorId,
      );

      Get.find<DesignController>().updateCap(design);
      Get.toNamed(Routes.order, arguments: DesignItemType.cap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _DesignAppBar(title: 'تصميم القبعة', onBack: Get.back),
            Expanded(
              child: Column(
                children: [
                  _CapPreview(
                    key: _capPreviewKey,
                    baseColor: activeColor.color,
                    tasselColor: activeTassel.color,
                    fabricId: fabricId,
                    text: topText,
                    textColor: activeFontColor.color,
                    textRotation: _textRotation,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 20,
                            offset: Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _StepsHeader(
                            steps: const ['القماش واللون', 'التزيين', 'تأكيد'],
                            current: step,
                            onTap: (i) => setState(() => step = i),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _buildStepContent(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: PrimaryButton(
                              label: step < 2 ? 'التالي' : 'إتمام الطلب',
                              onPressed: _goNext,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (step == 0) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'نوع القماش',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: fabricOptions.map((fabric) {
              final selected = fabricId == fabric.id;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => fabricId = fabric.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          fabric.name,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.textMain,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fabric.description,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: selected
                                ? Colors.white70
                                : AppColors.textSec,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'لون القبعة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: scarfColors.map((color) {
              final selected = colorId == color.id;
              return GestureDetector(
                onTap: () => setState(() => colorId = color.id),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.6),
                      width: selected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'لون الشرشوبة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: tasselColors.map((color) {
              final selected = tasselColorId == color.id;
              return GestureDetector(
                onTap: () => setState(() => tasselColorId = color.id),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    if (step == 1) {
      return ListView(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'عبارة التخرج (اختياري)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            textAlign: TextAlign.right,
            decoration: const InputDecoration(hintText: 'مثال: مبروك التخرج'),
            controller: _topTextController,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'لون الخط',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: embroideryColors.map((c) {
                        final selected = fontColorId == c.id;
                        return GestureDetector(
                          onTap: () => setState(() => fontColorId = c.id),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? Colors.black : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'نوع الخط',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSec,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: fontId,
                      items: fontOptions
                          .map(
                            (f) => DropdownMenuItem(
                              value: f.id,
                              child: Text(f.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => fontId = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TextRotateControlsRow(
            title: 'تدوير نص القبعة',
            enabled: topText.isNotEmpty,
            onRotateLeft: () {
              setState(() {
                _textRotation -= 0.15;
              });
              _capPreviewKey.currentState?.updateTextRotation(_textRotation);
            },
            onRotateRight: () {
              setState(() {
                _textRotation += 0.15;
              });
              _capPreviewKey.currentState?.updateTextRotation(_textRotation);
            },
          ),
        ],
      );
    }

    final fabricName = fabricOptions
        .firstWhere((f) => f.id == fabricId, orElse: () => fabricOptions.first)
        .name;

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ملخص الطلب',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 10),
              _SummaryRow(
                label: 'القماش',
                value: '$fabricName - ${activeColor.name}',
              ),
              _SummaryRow(label: 'الشرشوبة', value: activeTassel.name),
              _SummaryRow(
                label: 'النص',
                value: topText.isEmpty ? '-' : topText,
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Text(
                    '75,000 ل.س',
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'السعر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CapPreview extends StatefulWidget {
  final Color baseColor;
  final Color tasselColor;
  final String fabricId;
  final String text;
  final Color textColor;
  final double textRotation;

  const _CapPreview({
    Key? key,
    required this.baseColor,
    required this.tasselColor,
    required this.fabricId,
    required this.text,
    required this.textColor,
    this.textRotation = 0,
  }) : super(key: key);

  bool get isSatin => fabricId == 'satin';

  @override
  State<_CapPreview> createState() => _CapPreviewState();
}

class _CapPreviewState extends State<_CapPreview> {
  double _textRotation = 0;

  @override
  void initState() {
    super.initState();
    _textRotation = widget.textRotation;
  }

  @override
  void didUpdateWidget(covariant _CapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textRotation != widget.textRotation) {
      _textRotation = widget.textRotation;
    }
  }

  void updateTextRotation(double value) {
    setState(() {
      _textRotation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.7)
                  ..rotateZ(0.8),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: widget.baseColor,
                    borderRadius: BorderRadius.circular(6),
                    gradient: widget.isSatin
                        ? const LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.white24,
                              Colors.black45,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _textRotation,
                          child: Text(
                            widget.text,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 80,
                child: Column(
                  children: [
                    Container(width: 3, height: 70, color: widget.tasselColor),
                    const SizedBox(height: 2),
                    Container(
                      width: 10,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.tasselColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  String city = 'دمشق';

  late DesignItemType type;

  @override
  void initState() {
    super.initState();
    type = Get.arguments as DesignItemType? ?? DesignItemType.scarf;

    final user = Get.find<UserController>().user.value;
    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    addressController = TextEditingController(text: user.address);
    city = user.city;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى تعبئة جميع الحقول',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final user = UserModel(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: city,
      address: addressController.text.trim(),
    );

    Get.find<UserController>().setUser(user);

    final designController = Get.find<DesignController>();
    final orderController = Get.find<OrderController>();

    if (type == DesignItemType.scarf) {
      orderController.createOrder(
        type: DesignItemType.scarf,
        user: user,
        scarf: designController.scarfDesign.value,
      );
    } else {
      orderController.createOrder(
        type: DesignItemType.cap,
        user: user,
        cap: designController.capDesign.value,
      );
    }

    Get.offAllNamed(Routes.success);
  }

  @override
  Widget build(BuildContext context) {
    final designController = Get.find<DesignController>();
    final scarf = designController.scarfDesign.value;
    final cap = designController.capDesign.value;

    final isScarf = type == DesignItemType.scarf;
    final scarfColor = scarfColors.firstWhere(
      (c) => c.id == scarf.colorId,
      orElse: () => scarfColors.first,
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _DesignAppBar(title: 'إتمام الطلب', onBack: () => Get.back()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isScarf
                                  ? scarfColor.color
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                isScarf ? '🧣' : '🎓',
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isScarf ? 'وشاح تخرج' : 'قبعة تخرج',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? 'اللون: ${scarfColor.name}'
                                      : 'لون القبعة: ${scarfColor.name}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isScarf
                                      ? 'النص: ${scarf.rightText} / ${scarf.leftText}'
                                      : 'النص: ${cap.topText}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isScarf ? '150,000 ل.س' : '75,000 ل.س',
                            style: const TextStyle(
                              color: AppColors.accentDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'بيانات المستلم',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'الاسم الكامل',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+963',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.textSec,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.left,
                                  decoration: const InputDecoration(
                                    labelText: 'رقم الجوال',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: city,
                            items: syriaCities
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => city = value);
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'المحافظة',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: addressController,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'العنوان',
                              hintText: 'المنطقة، الشارع...',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 18,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'طريقة الدفع',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFACC15)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.accentDark,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'الدفع عند الاستلام',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'ادفع نقداً عند استلام طلبك',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        isScarf ? '150,000 ل.س' : '75,000 ل.س',
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'الإجمالي',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(label: 'تأكيد الطلب', onPressed: _submit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends GetView<OrderController> {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = controller.lastOrderId.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'تم استلام طلبك بنجاح!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'شكراً لثقتك بنا. سيتم تجهيز طلبك وشحنه قريباً.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSec,
                  ),
                ),
                const SizedBox(height: 8),
                if (id != null)
                  Text(
                    'رقم الطلب: #$id',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSec,
                    ),
                  ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'ماذا سيحدث الآن؟',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• سيقوم فريقنا بمراجعة التصميم.\n'
                        '• قد نتواصل معك لتأكيد بعض التفاصيل.\n'
                        '• مدة التنفيذ المتوقعة: 3-5 أيام عمل.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'تتبع طلبي',
                  onPressed: () {
                    Get.offAllNamed(Routes.orders);
                  },
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends GetView<OrderController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _DesignAppBar(title: 'طلباتي', onBack: () => Get.back()),
            Expanded(
              child: Obx(() {
                if (controller.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 72,
                          color: AppColors.textSec,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'لا توجد طلبات بعد',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'ابدأ بتصميم وشاحك الخاص الآن!',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSec,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    final isScarf =
                        order.type == DesignItemType.scarf &&
                        order.scarfDesign != null;
                    final color = scarfColors.firstWhere(
                      (c) =>
                          c.id ==
                          (isScarf
                              ? order.scarfDesign!.colorId
                              : order.capDesign!.colorId),
                      orElse: () => scarfColors.first,
                    );

                    final price = isScarf ? '150,000' : '75,000';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color.color,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    isScarf ? '🧣' : '🎓',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      isScarf ? 'وشاح تخرج' : 'قبعة تخرج',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSec,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '$price ل.س',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMain,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '#${order.id}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSec,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const Spacer(),
          const Text(
            'الملف الشخصي',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _AvatarSection extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(
              () => Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    controller.avatarLetter.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 16,
                color: AppColors.textSec,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'تعديل الصورة الشخصية',
          style: TextStyle(fontSize: 12, color: AppColors.textSec),
        ),
      ],
    );
  }
}

class _FormSection extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _LabelWithIcon(
            icon: Icons.person_outline_rounded,
            label: 'الاسم الكامل',
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.nameController,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(hintText: 'الاسم الثلاثي'),
          ),
          const SizedBox(height: 16),
          _LabelWithIcon(icon: Icons.phone_iphone_rounded, label: 'رقم الجوال'),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Container(
                  width: 70,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '+963',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textSec,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: '9xxxxxxxx',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _LabelWithIcon(
            icon: Icons.location_on_outlined,
            label: 'المحافظة والعنوان',
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 52,
            child: Obx(
              () => DropdownButtonFormField<String>(
                isDense: true,
                isExpanded: true,
                value: controller.selectedCity.value,
                items: controller.cities
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedCity.value = value;
                  }
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textSec,
                ),
                decoration: const InputDecoration(
                  labelText: 'المحافظة',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.addressController,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              labelText: 'العنوان',
              hintText: 'الحي، الشارع، تفاصيل إضافية...',
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LabelWithIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, size: 16, color: AppColors.accentDark),
      ],
    );
  }
}

class _BottomSaveButton extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Obx(() {
        final saved = controller.isSaved.value;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: saved ? Colors.green : AppColors.primary,
            foregroundColor: saved ? Colors.white : AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
          ),
          onPressed: controller.save,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                saved
                    ? Icons.check_circle_outline_rounded
                    : Icons.save_outlined,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                saved ? 'تم الحفظ بنجاح' : 'حفظ التغييرات',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
