

import 'package:flutter/material.dart';
import 'package:valuebuyin/app_colors.dart';
// import '../utils/app_colors.dart';

class CategoryTab extends StatelessWidget {
  final String category;
  final bool isSelected;

  const CategoryTab({super.key, required this.category, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}