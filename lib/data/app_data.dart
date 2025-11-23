import 'package:flutter/material.dart';
import '../models/product_model.dart';

const List<String> syriaCities = [
  'دمشق',
  'ريف دمشق',
  'حلب',
  'حمص',
  'اللاذقية',
  'طرطوس',
  'حماة',
  'درعا',
  'السويداء',
  'دير الزور',
  'الحسكة',
  'الرقة',
  'إدلب',
  'القنيطرة',
];

const List<ProductModel> products = [
  ProductModel(
    id: 1,
    name: 'وشاح الفخامة الملكي',
    price: '150,000',
    emoji: '🎓',
    color: Color(0xFF020617), // slate-900
    category: 'men',
  ),
  ProductModel(
    id: 2,
    name: 'وشاح النخبة المخملي',
    price: '125,000',
    emoji: '✨',
    color: Color(0xFF7F1D1D), // red-900
    category: 'women',
  ),
  ProductModel(
    id: 3,
    name: 'وشاح التميز الذهبي',
    price: '140,000',
    emoji: '👑',
    color: Color(0xFF334155), // slate-700
    category: 'custom',
  ),
  ProductModel(
    id: 4,
    name: 'وشاح المستقبل',
    price: '130,000',
    emoji: '🚀',
    color: Color(0xFF0F172A), // blue-ish slate
    category: 'men',
  ),
];

