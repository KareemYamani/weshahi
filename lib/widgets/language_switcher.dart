import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../localization/local_manager.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      // استخدم الـ BuildContext مباشرة لتغيير اللغة
      onSelected: (loc) async {
        await context.setLocale(loc);
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(localManager.tr('lang.arabic')),
        ),
        PopupMenuItem(
          value: const Locale('ur'),
          child: Text(localManager.tr('lang.arabic_sy')),
        ),
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(localManager.tr('lang.english')),
        ),
      ],
    );
  }
}
