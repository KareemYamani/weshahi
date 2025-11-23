import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

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
