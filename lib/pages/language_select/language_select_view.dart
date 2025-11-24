import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../localization/local_manager.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  Future<void> _select(Locale loc) async {
    // await Prefs.setLocale(loc.languageCode, loc.countryCode);
    await localManager.setLocale(loc);
    Get.offAllNamed(Routes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.language, size: 64, color: AppColors.primary),
                  const SizedBox(height: 14),
                  Text(
                    localManager.tr('language_select.choose'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _LangTile(
                    title: localManager.tr('language_select.fusha'),
                    subtitle: localManager.tr('language_select.fusha_desc'),
                    onTap: () => _select(const Locale('ar')),
                    leading: const Text('ا', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 12),
                  _LangTile(
                    title: localManager.tr('language_select.syrian'),
                    subtitle: localManager.tr('language_select.syrian_desc'),
                    onTap: () => _select(const Locale('sa')),
                    leading: const Text('ش', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 12),
                  _LangTile(
                    title: localManager.tr('lang.english'),
                    subtitle: localManager.tr('language_select.english_desc'),
                    onTap: () => _select(const Locale('en')),
                    leading: const Text('A', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget leading;

  const _LangTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                  child: leading,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSec,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left_rounded, color: AppColors.textSec),
          ],
        ),
      ),
    );
  }
}
