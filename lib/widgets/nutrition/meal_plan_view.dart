import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nutrition_controller.dart';
import '../../models/detailed_meal_plan.dart';
import 'daily_nutrition_summary.dart';
import 'meal_card.dart';

class MealPlanView extends StatelessWidget {
  final NutritionController nutritionController;
  final TabController tabController;
  final AnimationController animationController;
  final AnimationController loopingAnimationController;
  final AnimationController pageTransitionController;

  const MealPlanView({
    Key? key,
    required this.nutritionController,
    required this.tabController,
    required this.animationController,
    required this.loopingAnimationController,
    required this.pageTransitionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add some vertical space for better positioning
        SizedBox(height: MediaQuery.of(context).padding.top),
        _buildWeekDayPicker(context),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: nutritionController.weekdays.map((day) {
              return _buildDayContent(day);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayPicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                "Week Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
            ),
            SizedBox(
              height: 80, // Increased height to accommodate content
              child: Obx(() => TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[700],
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                onTap: (index) {
                  // Update the selectedDay when tab is tapped
                  nutritionController.changeSelectedDay(nutritionController.weekdays[index]);
                  
                  // Keep tab controller and selected day in sync
                  tabController.animateTo(index);
                },
                tabs: List.generate(nutritionController.weekdays.length, (index) {
                  final day = nutritionController.weekdays[index];
                  
                  // Now this will be reactive to changes in selectedDay
                  final isSelected = day == nutritionController.selectedDay.value;
                  
                  // Get day icon
                  IconData dayIcon = _getDayIcon(day);
                  
                  return AnimatedTabWidget(
                    isSelected: isSelected,
                    dayName: day,
                    dayIcon: dayIcon, 
                    dayDate: _getDayDate(index),
                    animationController: loopingAnimationController,
                  );
                }).toList(),
              )),
            ),
          ],
        ),
      ),
    );
  }

  // Get an icon for each day of the week
  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.wb_sunny_outlined;
      case 'tuesday':
        return Icons.sports_handball;
      case 'wednesday':
        return Icons.local_cafe_outlined;
      case 'thursday':
        return Icons.directions_run;
      case 'friday':
        return Icons.celebration;
      case 'saturday':
        return Icons.weekend;
      case 'sunday':
        return Icons.self_improvement;
      default:
        return Icons.calendar_today;
    }
  }

  // Get a simulated date for each day (just for visual appeal)
  String _getDayDate(int index) {
    // Get current date
    final now = DateTime.now();
    // Find the day of the week (1-7, where 1 is Monday)
    final todayWeekday = now.weekday;
    // Calculate the difference to get to the requested day
    final difference = index + 1 - todayWeekday;
    // Get the date for the requested day
    final date = now.add(Duration(days: difference));
    // Return the date in the format "DD/MM"
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }

  Widget _buildDayContent(String day) {
    return AnimatedBuilder(
      animation: pageTransitionController,
      builder: (context, child) {
        // Create a DetailedMealPlan from the controller's data for the current day
        final currentDayPlan = nutritionController.getCurrentDayPlan(day);
        
        return FadeTransition(
          opacity: pageTransitionController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: pageTransitionController,
                curve: Curves.easeOut,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 24, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nutrition summary at top
                  DailyNutritionSummary(
                    mealPlan: currentDayPlan,
                    animationController: animationController,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Meals list
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: currentDayPlan.meals.length,
                    itemBuilder: (context, index) {
                      final meal = currentDayPlan.meals[index];
                      return MealCard(
                        meal: meal,
                        animation: animationController,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRateButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How do you like this plan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => nutritionController.ratePlan(5), // Use ratePlan instead of likePlan
            icon: const Icon(Icons.thumb_up),
            label: const Text('Love it'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF388E3C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// New widget for animated tabs with highlight and ripple effects
class AnimatedTabWidget extends StatelessWidget {
  final bool isSelected;
  final String dayName;
  final IconData dayIcon;
  final String dayDate;
  final AnimationController animationController;

  const AnimatedTabWidget({
    Key? key,
    required this.isSelected,
    required this.dayName,
    required this.dayIcon,
    required this.dayDate,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 70, // Set explicit height for the tab
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          // Create pulsating effect for selected day
          final pulseValue = isSelected 
              ? 1.0 + (animationController.value * 0.03) 
              : 1.0;
          
          // Create glowing effect for selected day
          final glowColor = isSelected 
              ? const Color(0xFF388E3C).withOpacity(0.3 + (animationController.value * 0.1))
              : Colors.transparent;
              
          return Transform.scale(
            scale: pulseValue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Reduced vertical padding
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected 
                  ? [BoxShadow(
                      color: glowColor,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    )]
                  : null,
                gradient: isSelected 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2E7D32),
                        const Color(0xFF388E3C),
                      ],
                    )
                  : null,
                color: isSelected ? null : Colors.grey[100],
                border: !isSelected ? Border.all(color: Colors.grey.withOpacity(0.2), width: 1) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Use minimum space horizontally
                children: [
                  Icon(
                    dayIcon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: isSelected ? 20 : 16,
                  ),
                  const SizedBox(width: 6),
                  Column(
                    mainAxisSize: MainAxisSize.min, // Use minimum space vertically
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName.substring(0, 3).toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: isSelected ? 14 : 13,
                        ),
                      ),
                      const SizedBox(height: 2), // Reduced spacing
                      Text(
                        dayDate,
                        style: TextStyle(
                          fontSize: isSelected ? 10 : 9, // Slightly smaller font
                          color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
