import 'package:flutter/material.dart';
import 'user_model.dart';

enum DesignItemType { scarf, cap }

class ScarfColor {
  final String id;
  final String name;
  final Color color;

  const ScarfColor({required this.id, required this.name, required this.color});
}

class TasselColor {
  final String id;
  final String name;
  final Color color;

  const TasselColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

class EmbroideryColor {
  final String id;
  final String name;
  final Color color;

  const EmbroideryColor({
    required this.id,
    required this.name,
    required this.color,
  });
}

class ArabicFontOption {
  final String id;
  final String name;

  const ArabicFontOption({required this.id, required this.name});
}

class FabricOption {
  final String id;
  final String name;
  final String description;

  const FabricOption({
    required this.id,
    required this.name,
    required this.description,
  });
}

class ScarfDesignData {
  final String colorId;
  final String fabricId;
  final String rightText;
  final String leftText;
  final String fontId;
  final String fontColorId;

  const ScarfDesignData({
    required this.colorId,
    required this.fabricId,
    required this.rightText,
    required this.leftText,
    required this.fontId,
    required this.fontColorId,
  });
}

class CapDesignData {
  final String colorId;
  final String fabricId;
  final String tasselColorId;
  final String topText;
  final String fontId;
  final String fontColorId;

  const CapDesignData({
    required this.colorId,
    required this.fabricId,
    required this.tasselColorId,
    required this.topText,
    required this.fontId,
    required this.fontColorId,
  });
}

class OrderModel {
  final int id;
  final DateTime createdAt;
  final DesignItemType type;
  final ScarfDesignData? scarfDesign;
  final CapDesignData? capDesign;
  final UserModel user;
  final String status;

  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.scarfDesign,
    required this.capDesign,
    required this.user,
    required this.status,
  });
}
