import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nutrition_controller.dart';
import 'components/detailed_meal_card.dart';

class DayMeals extends StatelessWidget {
  final NutritionController nutritionController;
  final AnimationController pageTransitionController;
  final AnimationController animationController;

  const DayMeals({
    Key? key,
    required this.nutritionController,
    required this.pageTransitionController,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: pageTransitionController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(pageTransitionController),
        child: Obx(() {
          final selectedDayPlan = nutritionController.getSelectedDayMealPlan();
          
          if (selectedDayPlan == null) {
            return const Center(
              child: Text('No meal plan available for this day'),
            );
          }
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailedMealCard(
                  mealType: 'Breakfast',
                  meal: selectedDayPlan.breakfast,
                  icon: Icons.breakfast_dining,
                  delayStart: 0.0,
                  animationController: animationController,
                  nutritionController: nutritionController,
                ),
                DetailedMealCard(
                  mealType: 'Snack',
                  meal: selectedDayPlan.snack,
                  icon: Icons.cookie,
                  delayStart: 0.2,
                  animationController: animationController,
                  nutritionController: nutritionController,
                ),
                DetailedMealCard(
                  mealType: 'Lunch',
                  meal: selectedDayPlan.lunch,
                  icon: Icons.lunch_dining,
                  delayStart: 0.4,
                  animationController: animationController,
                  nutritionController: nutritionController,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
