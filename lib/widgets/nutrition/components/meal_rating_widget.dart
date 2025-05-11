import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../controllers/nutrition_controller.dart';

class MealRatingWidget extends StatelessWidget {
  final String day;
  final String mealType;
  final NutritionController nutritionController;

  const MealRatingWidget({
    Key? key,
    required this.day,
    required this.mealType,
    required this.nutritionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = '${day}_$mealType';
    final currentRating = nutritionController.mealRatings[key] ?? 0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: currentRating.toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 36,
          glow: false,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            HapticFeedback.lightImpact();
            nutritionController.setMealRating(day, mealType, rating.toInt());
          },
        ),
        if (currentRating > 0)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentRating >= 4
                          ? Colors.green.shade50
                          : currentRating >= 2
                              ? Colors.amber.shade50
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: currentRating >= 4
                            ? Colors.green.shade300
                            : currentRating >= 2
                                ? Colors.amber.shade300
                                : Colors.red.shade300,
                      ),
                    ),
                    child: Text(
                      currentRating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: currentRating >= 4
                            ? Colors.green.shade700
                            : currentRating >= 2
                                ? Colors.amber.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
