import 'package:flutter/material.dart';
import '../../models/detailed_meal_plan.dart';

class DailyNutritionSummary extends StatelessWidget {
  final DetailedMealPlan mealPlan;
  final AnimationController animationController;
  
  const DailyNutritionSummary({
    Key? key,
    required this.mealPlan,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total nutrition for the day from all meals
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    
    // Sum up nutrients from all meals
    for (var meal in mealPlan.meals) {
      totalCalories += meal.calories;
      totalProtein += meal.protein;
      totalCarbs += meal.carbs;
      totalFat += meal.fat;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_menu, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  'Daily Nutrition Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NutrientCircle(
                  value: totalCalories.toInt(),
                  label: 'Calories',
                  unit: 'kcal',
                  color: Colors.green,
                  animation: animationController,
                ),
                _NutrientCircle(
                  value: totalProtein.toInt(),
                  label: 'Protein',
                  unit: 'g',
                  color: Colors.red,
                  animation: animationController,
                ),
                _NutrientCircle(
                  value: totalCarbs.toInt(),
                  label: 'Carbs',
                  unit: 'g',
                  color: Colors.orange,
                  animation: animationController,
                ),
                _NutrientCircle(
                  value: totalFat.toInt(),
                  label: 'Fat',
                  unit: 'g',
                  color: Colors.blue,
                  animation: animationController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientCircle extends StatelessWidget {
  final int value;
  final String label;
  final String unit;
  final Color color;
  final AnimationController animation;

  const _NutrientCircle({
    Key? key,
    required this.value,
    required this.label,
    required this.unit,
    required this.color,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animValue = animation.value;
        return Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
            Text(
              unit,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        );
      },
    );
  }
}
