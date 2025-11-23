import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/app_data.dart';
import '../models/user_model.dart';
import 'user_controller.dart';
import '../routes/app_routes.dart';

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
