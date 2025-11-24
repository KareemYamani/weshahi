import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'localization/local_manager.dart';
import 'localization/weshahi_asset_loader.dart';

import 'bindings/app_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/localization_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Allow LocalManager to resolve a context using GetX's navigator key.
  localManager.navigatorKey = Get.key;

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationService.supportedLocales,
      path: 'assets/translations',
      assetLoader: const WeshahiAssetLoader(),
      startLocale: const Locale('ar', 'SA'),
      useOnlyLangCode: false,
      fallbackLocale: LocalizationService.fallbackLocale,
      saveLocale: true,
      child: const WeshahiApp(),
    ),
  );
}

class WeshahiApp extends StatelessWidget {
  const WeshahiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: localManager.tr('app.title'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBinding(),
      initialRoute: Routes.language,
      getPages: AppPages.pages,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
