import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// Custom asset loader to precisely control which JSON file
/// is used for each locale, especially for the two Arabic variants.
class WeshahiAssetLoader extends AssetLoader {
  const WeshahiAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final candidates = <String>[];

    if (locale.languageCode == 'ar' && (locale.countryCode ?? '').isNotEmpty) {
      // Arabic (Syrian / colloquial) variant.
      candidates.addAll(<String>[
        '$path/ar-SA.json',
        '$path/ar_SA.json',
        '$path/ar-sa.json',
        '$path/ar_sa.json',
        '$path/sa.json',
      ]);
    }

    // Language-only fallback (standard Arabic, English, etc.).
    candidates.add('$path/${locale.languageCode}.json');

    for (final file in candidates) {
      try {
        final data = await rootBundle.loadString(file);
        return json.decode(data) as Map<String, dynamic>;
      } catch (_) {
        // Try next candidate.
      }
    }

    // As a last resort, return empty map to avoid crashes.
    return const {};
  }
}

