import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/app_data.dart';
import '../models/user_model.dart';
import 'user_controller.dart';
import '../routes/app_routes.dart';
import '../services/prefs.dart';

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
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      error.value = 'يرجى تعبئة جميع الحقول';
      return;
    }

    final user = UserModel(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: selectedCity.value,
      address: addressController.text.trim(),
    );
    Get.find<UserController>().setUser(user);
    // Persist user locally
    Prefs.saveUser(user);
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
