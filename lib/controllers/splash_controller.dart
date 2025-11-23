import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/prefs.dart';

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

    _decideNext();
  }

  Future<void> _decideNext() async {
    // Keep splash for a short pleasant duration
    await Future.delayed(const Duration(milliseconds: 1200));

    // Ensure language chosen once
    final (lang, _) = await Prefs.getLocale();
    if (lang == null) {
      Get.offAllNamed(Routes.language);
      return;
    }

    final hasUser = await Prefs.hasUser();
    if (hasUser) {
      Get.offAllNamed(Routes.home);
      return;
    }

    final done = await Prefs.getOnboardingDone();
    if (!done) {
      Get.offAllNamed(Routes.onboarding);
    } else {
      Get.offAllNamed(Routes.userInfo);
    }
  }

  @override
  void onClose() {
    logoController.dispose();
    super.onClose();
  }
}
