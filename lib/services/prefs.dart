import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class PrefsKeys {
  static const onboardingDone = 'onboarding_done';
  static const userName = 'user_name';
  static const userPhone = 'user_phone';
  static const userCity = 'user_city';
  static const userAddress = 'user_address';
  static const localeLang = 'locale_lang';
  static const localeCountry = 'locale_country';
}

class Prefs {
  static Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // Onboarding flag
  static Future<bool> getOnboardingDone() async {
    final p = await _prefs;
    return p.getBool(PrefsKeys.onboardingDone) ?? false;
  }

  static Future<void> setOnboardingDone(bool value) async {
    final p = await _prefs;
    await p.setBool(PrefsKeys.onboardingDone, value);
  }

  // User
  static Future<void> saveUser(UserModel user) async {
    final p = await _prefs;
    await p.setString(PrefsKeys.userName, user.name);
    await p.setString(PrefsKeys.userPhone, user.phone);
    await p.setString(PrefsKeys.userCity, user.city);
    await p.setString(PrefsKeys.userAddress, user.address);
  }

  static Future<UserModel?> loadUser() async {
    final p = await _prefs;
    final name = p.getString(PrefsKeys.userName) ?? '';
    final phone = p.getString(PrefsKeys.userPhone) ?? '';
    final city = p.getString(PrefsKeys.userCity) ?? 'دمشق';
    final address = p.getString(PrefsKeys.userAddress) ?? '';
    if (name.isEmpty && phone.isEmpty && address.isEmpty) return null;
    return UserModel(name: name, phone: phone, city: city, address: address);
  }

  static Future<bool> hasUser() async {
    final u = await loadUser();
    return u != null && u.name.isNotEmpty && u.phone.isNotEmpty;
  }

  // Locale
  static Future<void> setLocale(String languageCode, [String? countryCode]) async {
    final p = await _prefs;
    await p.setString(PrefsKeys.localeLang, languageCode);
    if (countryCode != null) {
      await p.setString(PrefsKeys.localeCountry, countryCode);
    } else {
      await p.remove(PrefsKeys.localeCountry);
    }
  }

  static Future<(String? lang, String? country)> getLocale() async {
    final p = await _prefs;
    final lang = p.getString(PrefsKeys.localeLang);
    final country = p.getString(PrefsKeys.localeCountry);
    return (lang, country);
  }
}
