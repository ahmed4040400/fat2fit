import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../controllers/nutrition_controller.dart';
import '../../../models/detailed_meal_plan.dart';

class EnhancedRatingItem extends StatelessWidget {
  final String day;
  final String mealType;
  final MealDetail meal;
  final NutritionController nutritionController;

  const EnhancedRatingItem({
    Key? key,
    required this.day,
    required this.mealType,
    required this.meal,
    required this.nutritionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData mealIcon = mealType == 'breakfast'
        ? Icons.breakfast_dining
        : mealType == 'snack'
            ? Icons.cookie
            : Icons.lunch_dining;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              // Could expand for more detail
            },
            splashColor: const Color(0xFF2E7D32).withOpacity(0.1),
            highlightColor: const Color(0xFF2E7D32).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          mealIcon,
                          color: const Color(0xFF2E7D32),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${mealType.substring(0, 1).toUpperCase()}${mealType.substring(1)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            Text(
                              meal.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${meal.calories} kcal',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedMealRatingWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedMealRatingWidget() {
    final key = '${day}_$mealType';
    final currentRating = nutritionController.mealRatings[key] ?? 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How was this meal?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBar.builder(
              initialRating: currentRating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 36,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, index) {
                return Icon(
                  Icons.star,
                  color: index < currentRating 
                      ? Colors.amber 
                      : Colors.grey.shade300,
                );
              },
              onRatingUpdate: (rating) {
                HapticFeedback.lightImpact();
                nutritionController.setMealRating(day, mealType, rating.toInt());
              },
            ),
            if (currentRating > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: currentRating >= 4
                      ? Colors.green.shade50
                      : currentRating >= 2
                          ? Colors.amber.shade50
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: currentRating >= 4
                        ? Colors.green.shade200
                        : currentRating >= 2
                            ? Colors.amber.shade200
                            : Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentRating >= 4
                          ? Icons.sentiment_very_satisfied
                          : currentRating >= 2
                              ? Icons.sentiment_neutral
                              : Icons.sentiment_very_dissatisfied,
                      size: 16,
                      color: currentRating >= 4
                          ? Colors.green
                          : currentRating >= 2
                              ? Colors.amber
                              : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currentRating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: currentRating >= 4
                            ? Colors.green
                            : currentRating >= 2
                                ? Colors.amber
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
