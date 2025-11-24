import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../localization/local_manager.dart';
import '../data/app_data.dart';
import '../models/user_model.dart';
import 'user_controller.dart';

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
      localManager.tr('profile.saved_title'),
      localManager.tr('profile.saved_message'),
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
