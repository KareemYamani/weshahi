import 'package:flutter/material.dart';

Color lighten(Color color, [double amount = 0.15]) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color darken(Color color, [double amount = 0.20]) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

LinearGradient satinGradient(Color base) {
  return LinearGradient(
    colors: [
      darken(base, 0.28),
      lighten(base, 0.18),
      darken(base, 0.22),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

