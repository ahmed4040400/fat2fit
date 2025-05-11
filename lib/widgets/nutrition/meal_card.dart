import 'package:flutter/material.dart';
import '../../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final AnimationController animation;
  
  const MealCard({
    Key? key,
    required this.meal,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Card(
          elevation: 3 * animation.value,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal icon/image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMealIcon(),
                    size: 32,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Meal details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _NutrientChip(
                            label: '${meal.calories.toInt()} kcal',
                            icon: Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                          _NutrientChip(
                            label: '${meal.protein.toInt()}g protein',
                            icon: Icons.fitness_center,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Calories badge
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '${meal.calories.toInt()} kcal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  IconData _getMealIcon() {
    // Determine icon based on meal name or type
    if (meal.name.toLowerCase().contains('breakfast')) {
      return Icons.breakfast_dining;
    } else if (meal.name.toLowerCase().contains('lunch')) {
      return Icons.lunch_dining;
    } else if (meal.name.toLowerCase().contains('dinner')) {
      return Icons.dinner_dining;
    } else if (meal.name.toLowerCase().contains('snack')) {
      return Icons.cookie;
    }
    return Icons.restaurant;
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  
  const _NutrientChip({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(4),
      backgroundColor: color.withOpacity(0.1),
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color.withAlpha(220),
        ),
      ),
    );
  }
}
