import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/local_manager.dart';
import 'shared_prefs_service.dart';

class LocalizationService {
  final SharedPrefsService? _prefs;
  LocalizationService([this._prefs]);

  // Keep locales consistent with assets/translations/*
  // ar      -> Arabic (Fusha)
  // ar-SA   -> Arabic (Colloquial / Syrian style)
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('ur'),
    Locale('en'),
  ];

  static const Locale fallbackLocale = Locale('ar');

  static Locale get system => ui.PlatformDispatcher.instance.locale;

  Locale resolveInitialLocale({Locale? fallback}) {
    final fb = fallback ?? fallbackLocale;
    final saved = _prefs?.getString(_prefsLocaleKey);
    if (saved != null && saved.isNotEmpty) {
      final found = supportedLocales.firstWhere(
        (l) => l.toString() == saved || l.languageCode == saved,
        orElse: () => fb,
      );
      return found;
    }

    final sys = system;
    final matched = supportedLocales.firstWhere(
      (l) => l.languageCode == sys.languageCode,
      orElse: () => fb,
    );
    return matched;
  }

  Future<void> setLocale(Locale locale) async {
    // Update via LocalManager (no BuildContext required here)
    await localManager.setLocale(locale);
    await _prefs?.setString(_prefsLocaleKey, locale.toString());
  }

  Future<Locale> toggleLocale() async {
    final current = localManager.locale ?? fallbackLocale;
    final idx = supportedLocales.indexWhere(
      (l) =>
          l.languageCode == current.languageCode &&
          l.countryCode == current.countryCode,
    );
    final next = supportedLocales[(idx + 1) % supportedLocales.length];
    await setLocale(next);
    return next;
  }
}

const String _prefsLocaleKey = 'locale';
