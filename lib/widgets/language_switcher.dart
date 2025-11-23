import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (loc) async {
        await context.setLocale(loc);
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(tr('lang.arabic')),
        ),
        PopupMenuItem(
          value: const Locale('ar', 'SY'),
          child: Text(tr('lang.arabic_sy')),
        ),
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(tr('lang.english')),
        ),
      ],
    );
  }
}

