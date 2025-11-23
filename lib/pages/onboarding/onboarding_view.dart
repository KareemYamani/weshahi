import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/onboarding_controller.dart';
import '../../routes/app_routes.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.slides.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (_, i) {
                  final s = controller.slides[i];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s.icon, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                          i == 0
                              ? tr('onboarding.title1')
                              : i == 1
                                  ? tr('onboarding.title2')
                                  : tr('onboarding.title3'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18)),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                            i == 0
                                ? tr('onboarding.desc1')
                                : i == 1
                                    ? tr('onboarding.desc2')
                                    : tr('onboarding.desc3'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSec)),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Obx(() => Text(
                        '${controller.currentIndex.value + 1}/${controller.slides.length}',
                        style: const TextStyle(color: AppColors.textSec),
                      )),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.isLast) {
                        Get.offAllNamed(Routes.userInfo);
                      } else {
                        controller.next();
                      }
                    },
                    child: Obx(() => Text(
                        controller.isLast ? tr('onboarding.start') : tr('onboarding.next'))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
