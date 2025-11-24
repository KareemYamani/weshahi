import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

/// A lightweight facade over easy_localization to provide
/// a global `localManager.tr('key')` API without requiring BuildContext.
class LocalManager {
  LocalManager._internal();
  static final LocalManager instance = LocalManager._internal();

  /// Optional navigator key to resolve a context when translating.
  /// Defaults to GetX's global key if available.
  GlobalKey<NavigatorState>? navigatorKey;

  /// Convenient accessor for resolved context.
  BuildContext? get _ctx =>
      (navigatorKey ?? Get.key).currentContext ?? Get.context;

  /// Translate the given key using easy_localization.
  /// If no context is available yet, returns [fallback] or the key itself.
  String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
    String? fallback,
  }) {
    final ctx = _ctx;
    if (ctx == null) return fallback ?? key;
    // Use the String extension with explicit context to avoid relying on implicit context.
    return ez.tr(
      key,
      context: ctx,
      args: args,
      namedArgs: namedArgs,
      gender: gender,
    );
  }

  /// Current locale if available.
  Locale? get locale => _ctx?.locale;

  /// Supported locales if available from the widget tree.
  List<Locale> get supportedLocales => _ctx?.supportedLocales ?? const [];

  /// Change the app locale via easy_localization.
  Future<void> setLocale(Locale locale) async {
    final ctx = _ctx;
    if (ctx != null) {
      await ctx.setLocale(locale);
    }
  }

  // Static convenience to support calls like `LocalManager.tr('key')`.
  static String trManger(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
    String? fallback,
  }) => LocalManager.instance.tr(
    key,
    args: args,
    namedArgs: namedArgs,
    gender: gender,
    fallback: fallback,
  );
}

/// Global instance for easy access: `localManager.tr('key')`.
final localManager = LocalManager.instance;

// Short alias function: `t('key')`.
String t(
  String key, {
  List<String>? args,
  Map<String, String>? namedArgs,
  String? gender,
  String? fallback,
}) => localManager.tr(
  key,
  args: args,
  namedArgs: namedArgs,
  gender: gender,
  fallback: fallback,
);
