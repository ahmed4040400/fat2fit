import 'package:flutter/material.dart';
import '../../controllers/nutrition_controller.dart';
import 'components/enhanced_rating_item.dart';

class RatingForm extends StatelessWidget {
  final NutritionController nutritionController;
  final AnimationController animationController;

  const RatingForm({
    Key? key,
    required this.nutritionController,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reset animation controller and forward it again for new content
    animationController.reset();
    animationController.forward();
    
    final dailyPlans = nutritionController.detailedMealPlan.value?.weeklyPlan ?? [];
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: animationController,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      const Color(0xFFF1F8E9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
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
                          child: const Icon(
                            Icons.star,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rate Your Meals',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Help us improve your plan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyPlans.length,
            itemBuilder: (context, dayIndex) {
              final dayPlan = dailyPlans[dayIndex];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval(
                    0.2 + (dayIndex * 0.05),
                    0.9,
                    curve: Curves.easeOutCubic,
                  ),
                )),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animationController,
                    curve: Interval(
                      0.3 + (dayIndex * 0.05),
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                dayPlan.day.substring(0, 3),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dayPlan.day,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      EnhancedRatingItem(
                        day: dayPlan.day,
                        mealType: 'breakfast',
                        meal: dayPlan.breakfast,
                        nutritionController: nutritionController,
                      ),
                      EnhancedRatingItem(
                        day: dayPlan.day,
                        mealType: 'snack',
                        meal: dayPlan.snack,
                        nutritionController: nutritionController,
                      ),
                      EnhancedRatingItem(
                        day: dayPlan.day,
                        mealType: 'lunch',
                        meal: dayPlan.lunch,
                        nutritionController: nutritionController,
                      ),
                      if (dayIndex < dailyPlans.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: const Color(0xFF2E7D32).withOpacity(0.4),
              minimumSize: const Size(double.infinity, 56),
            ),
            onPressed: () {
              nutritionController.submitRatings();
            },
            child: const Text(
              'Submit Ratings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                nutritionController.showRatingForm.value = false;
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Skip Rating',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
