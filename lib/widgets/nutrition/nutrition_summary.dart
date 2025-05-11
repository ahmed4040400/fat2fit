import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nutrition_controller.dart';
import 'components/nutrient_indicator.dart';

class NutritionSummary extends StatelessWidget {
  final NutritionController nutritionController;
  final AnimationController loopingAnimationController;
  final AnimationController animationController;

  const NutritionSummary({
    Key? key,
    required this.nutritionController,
    required this.loopingAnimationController,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.rotate(
                  angle: loopingAnimationController.value * 0.05,
                  child: const Icon(
                    Icons.restaurant,
                    color: Color(0xFF2E7D32),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Daily Nutrition Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AnimatedNutrientIndicator(
                    label: 'Calories',
                    value: nutritionController.totalCalories.value.toString(),
                    unit: 'kcal',
                    color: const Color(0xFF2E7D32),
                    delay: 0.0,
                    animationController: animationController,
                  ),
                ),
                Expanded(
                  child: AnimatedNutrientIndicator(
                    label: 'Protein',
                    value: nutritionController.totalProtein.value.toStringAsFixed(1),
                    unit: 'g',
                    color: Colors.red.shade700,
                    delay: 0.2,
                    animationController: animationController,
                  ),
                ),
                Expanded(
                  child: AnimatedNutrientIndicator(
                    label: 'Carbs',
                    value: nutritionController.totalCarbs.value.toStringAsFixed(1),
                    unit: 'g',
                    color: Colors.amber.shade800,
                    delay: 0.4,
                    animationController: animationController,
                  ),
                ),
                Expanded(
                  child: AnimatedNutrientIndicator(
                    label: 'Fat',
                    value: nutritionController.totalFat.value.toStringAsFixed(1),
                    unit: 'g',
                    color: Colors.blue.shade700,
                    delay: 0.6,
                    animationController: animationController,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
