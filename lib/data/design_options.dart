import 'package:flutter/material.dart';
import '../models/design_and_order_models.dart';

const List<ScarfColor> scarfColors = [
  ScarfColor(id: 'navy', name: 'كحلي ملكي', color: Color(0xFF0F172A)),
  ScarfColor(id: 'maroon', name: 'عنابي فاخر', color: Color(0xFF7F1D1D)),
  ScarfColor(id: 'black', name: 'أسود ليلي', color: Color(0xFF020617)),
  ScarfColor(id: 'emerald', name: 'زمردي', color: Color(0xFF064E3B)),
  ScarfColor(id: 'white', name: 'أبيض نقي', color: Color(0xFFF1F5F9)),
];

const List<TasselColor> tasselColors = [
  TasselColor(id: 'gold', name: 'ذهبي', color: Color(0xFFFBBF24)),
  TasselColor(id: 'black', name: 'أسود', color: Color(0xFF000000)),
  TasselColor(id: 'blue', name: 'أزرق', color: Color(0xFF1D4ED8)),
  TasselColor(id: 'red', name: 'أحمر', color: Color(0xFFB91C1C)),
  TasselColor(id: 'white', name: 'أبيض', color: Color(0xFFFFFFFF)),
];

const List<EmbroideryColor> embroideryColors = [
  EmbroideryColor(id: 'gold', name: 'ذهبي لامع', color: Color(0xFFFBBF24)),
  EmbroideryColor(id: 'silver', name: 'فضي', color: Color(0xFFCBD5E1)),
  EmbroideryColor(id: 'white', name: 'أبيض', color: Color(0xFFFFFFFF)),
  EmbroideryColor(id: 'black', name: 'أسود', color: Color(0xFF000000)),
];

const List<ArabicFontOption> fontOptions = [
  ArabicFontOption(id: 'thuluth', name: 'خط الثلث'),
  ArabicFontOption(id: 'kufi', name: 'كوفي هندسي'),
  ArabicFontOption(id: 'diwani', name: 'ديواني مزخرف'),
];

const List<FabricOption> fabricOptions = [
  FabricOption(id: 'velvet', name: 'مخمل', description: 'فخم، دافئ، غير لامع'),
  FabricOption(id: 'satin', name: 'ساتان', description: 'ناعم، لامع، انسيابي'),
];
