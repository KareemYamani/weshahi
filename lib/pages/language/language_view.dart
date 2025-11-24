import 'package:flutter/material.dart';
import '../../localization/local_manager.dart';
import '../../theme/app_theme.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  Future<void> _select(BuildContext context, Locale locale) async {
    // await localManager.setLocale(locale);
    // await Prefs.setLocale(locale.languageCode, locale.countryCode);
    // final hasUser = await Prefs.hasUser();
    // final done = await Prefs.getOnboardingDone();
    // if (hasUser) {
    //   Get.offAllNamed(Routes.home);
    // } else if (!done) {
    //   Get.offAllNamed(Routes.onboarding);
    // } else {
    //   Get.offAllNamed(Routes.userInfo);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(localManager.tr('language_select.choose'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _LangCard(
              title: localManager.tr('language_select.fusha'),
              subtitle: localManager.tr('language_select.fusha_desc'),
              emoji: '📚',
              onTap: () => _select(context, const Locale('ar')),
            ),
            const SizedBox(height: 12),
            _LangCard(
              title: localManager.tr('language_select.syrian'),
              subtitle: localManager.tr('language_select.syrian_desc'),
              emoji: '😄',
              onTap: () => _select(context, const Locale('sa')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final VoidCallback onTap;
  const _LangCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSec),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
