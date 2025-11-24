import 'package:flutter/material.dart';
import '../localization/local_manager.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (loc) async {
        await localManager.setLocale(loc);
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(localManager.tr('lang.arabic')),
        ),
        PopupMenuItem(
          value: const Locale('sa'),
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
