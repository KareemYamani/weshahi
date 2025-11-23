import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;
  final String price;
  final String emoji;
  final Color color;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.color,
    required this.category,
  });
}
