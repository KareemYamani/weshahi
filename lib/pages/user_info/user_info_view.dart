import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/user_info_controller.dart';

class UserInfoPage extends GetView<UserInfoController> {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(tr('user_info.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(labelText: tr('user_info.name')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(labelText: tr('user_info.phone')),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.addressController,
              decoration: InputDecoration(labelText: tr('user_info.address')),
            ),
            const SizedBox(height: 12),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCity.value,
                  items: controller.cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => controller.selectedCity.value = v ?? 'دمشق',
                  decoration: InputDecoration(labelText: tr('user_info.city')),
                )),
            const Spacer(),
            Obx(() => controller.error.value.isEmpty
                ? const SizedBox.shrink()
                : Text(controller.error.value,
                    style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: controller.submit,
              child: Text(tr('user_info.save_continue')),
            )
          ],
        ),
      ),
    );
  }
}
