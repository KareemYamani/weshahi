import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

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
