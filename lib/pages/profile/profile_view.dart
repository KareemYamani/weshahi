import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/profile_controller.dart';
import '../../services/prefs.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(tr('profile.title'))),
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
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                tr('language_select.choose'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 6),
            const _LangRadioRow(),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.save,
              child: Text(tr('common.save')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangRadioRow extends StatelessWidget {
  const _LangRadioRow();

  @override
  Widget build(BuildContext context) {
    final current = context.locale;
    final isFusha = current.languageCode == 'ar' && current.countryCode == null;
    final isSyrian = current.languageCode == 'ar' && current.countryCode == 'SY';
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: isFusha,
            onChanged: (_) async {
              final loc = const Locale('ar');
              await context.setLocale(loc);
              await Prefs.setLocale('ar');
            },
            title: Text(tr('language_select.fusha')),
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: isSyrian,
            onChanged: (_) async {
              final loc = const Locale('ar', 'SY');
              await context.setLocale(loc);
              await Prefs.setLocale('ar', 'SY');
            },
            title: Text(tr('language_select.syrian')),
          ),
        ),
      ],
    );
  }
}
