import 'package:flutter/material.dart';
import '../../../models/detailed_meal_plan.dart';
import 'nutrition_bar_value.dart';

class EnhancedNutritionInfoBar extends StatelessWidget {
  final NutritionInfo nutrition;

  const EnhancedNutritionInfoBar({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedNutritionBarValue(
            label: 'Protein',
            value: nutrition.protein,
            unit: 'g',
            color: Colors.red.shade700,
          ),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          AnimatedNutritionBarValue(
            label: 'Carbs',
            value: nutrition.carbs,
            unit: 'g',
            color: Colors.amber.shade800,
          ),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          AnimatedNutritionBarValue(
            label: 'Fat',
            value: nutrition.fat,
            unit: 'g',
            color: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }
}
