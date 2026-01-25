import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final Color color;
  final bool isFree;
  final int questionCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.isFree,
    this.questionCount = 200,
  });
}
