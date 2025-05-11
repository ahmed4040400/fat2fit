import 'dart:developer' as developer;

import '../models/detailed_meal_plan.dart';
import '../models/meal.dart' as app_meal;
import '../models/nutrition_models.dart';
import '../services/nutrition_service.dart';
import 'package:flutter/foundation.dart';

class MealPlanService {
  final NutritionService _nutritionService;
  
  MealPlanService({NutritionService? nutritionService}) 
    : _nutritionService = nutritionService ?? NutritionService();
  
  /// Generate a new meal plan using the session ID
  Future<DetailedWeeklyPlan> generatePlan(String sessionId) async {
    try {
      final plan = await _nutritionService.generatePlan(sessionId);
      return plan;
    } catch (e) {
      developer.log('Error generating meal plan', name: 'MealPlanService', error: e.toString());
      rethrow;
    }
  }
  
  /// Regenerate the meal plan based on ratings
  Future<DetailedWeeklyPlan> regeneratePlan(String sessionId) async {
    try {
      final plan = await _nutritionService.regeneratePlan(sessionId);
      return plan;
    } catch (e) {
      developer.log('Error regenerating meal plan', name: 'MealPlanService', error: e.toString());
      rethrow;
    }
  }
  
  /// Submit feedback about the meal plan
  Future<FeedbackResponse> submitPlanFeedback(String sessionId, String feedback) async {
    try {
      final response = await _nutritionService.submitPlanFeedback(sessionId, feedback);
      return response;
    } catch (e) {
      developer.log('Error submitting feedback', name: 'MealPlanService', error: e.toString());
      rethrow;
    }
  }
  
  /// Submit ratings for meals
  Future<FeedbackResponse> submitMealRatings(String sessionId, Map<String, int> ratings) async {
    try {
      final response = await _nutritionService.submitMealRatings(sessionId, ratings);
      return response;
    } catch (e) {
      developer.log('Error submitting meal ratings', name: 'MealPlanService', error: e.toString());
      rethrow;
    }
  }
  
  /// Convert daily meal plan to app format
  DetailedMealPlan convertDailyPlanToAppFormat(DailyMealPlan dailyPlan) {
    try {
      List<app_meal.Meal> meals = [];
      
      // Add breakfast
      meals.add(app_meal.Meal(
        name: "Breakfast: ${dailyPlan.breakfast.name}",
        description: dailyPlan.breakfast.recipe,
        calories: dailyPlan.breakfast.calories.toDouble(),
        protein: dailyPlan.breakfast.nutrition.protein,
        carbs: dailyPlan.breakfast.nutrition.carbs,
        fat: dailyPlan.breakfast.nutrition.fat,
        ingredients: [], // Add ingredients if available
        steps: [], // Add steps if available
      ));

      // Debug log for Arabic text
      if (kDebugMode) {
        developer.log('Breakfast name: ${dailyPlan.breakfast.name}', name: 'MealPlanService');
        developer.log('Breakfast recipe sample: ${dailyPlan.breakfast.recipe.substring(0, min(50, dailyPlan.breakfast.recipe.length))}...', 
            name: 'MealPlanService');
      }

      // Add snack
      meals.add(app_meal.Meal(
        name: "Snack: ${dailyPlan.snack.name}",
        description: dailyPlan.snack.recipe,
        calories: dailyPlan.snack.calories.toDouble(),
        protein: dailyPlan.snack.nutrition.protein,
        carbs: dailyPlan.snack.nutrition.carbs,
        fat: dailyPlan.snack.nutrition.fat,
        ingredients: [], // Add ingredients if available
        steps: [], // Add steps if available
      ));

      // Add lunch
      meals.add(app_meal.Meal(
        name: "Lunch: ${dailyPlan.lunch.name}",
        description: dailyPlan.lunch.recipe,
        calories: dailyPlan.lunch.calories.toDouble(),
        protein: dailyPlan.lunch.nutrition.protein,
        carbs: dailyPlan.lunch.nutrition.carbs,
        fat: dailyPlan.lunch.nutrition.fat,
        ingredients: [], // Add ingredients if available
        steps: [], // Add steps if available
      ));

      return DetailedMealPlan(
        meals: meals,
        day: dailyPlan.day,
      );
    } catch (e) {
      developer.log('Error converting daily plan', name: 'MealPlanService', error: e.toString());
      return DetailedMealPlan(
        meals: [],
        day: dailyPlan.day,
      );
    }
  }
  
  // Helper method to get the minimum of two numbers
  int min(int a, int b) => a < b ? a : b;
  
  /// Calculate nutrition totals for a daily meal plan
  Map<String, dynamic> calculateDailyNutrition(DailyMealPlan dailyPlan) {
    try {
      int calories = 0;
      double protein = 0.0;
      double carbs = 0.0;
      double fat = 0.0;
      
      // Add breakfast nutrition
      calories += dailyPlan.breakfast.calories;
      protein += dailyPlan.breakfast.nutrition.protein;
      carbs += dailyPlan.breakfast.nutrition.carbs;
      fat += dailyPlan.breakfast.nutrition.fat;
      
      // Add snack nutrition
      calories += dailyPlan.snack.calories;
      protein += dailyPlan.snack.nutrition.protein;
      carbs += dailyPlan.snack.nutrition.carbs;
      fat += dailyPlan.snack.nutrition.fat;
      
      // Add lunch nutrition
      calories += dailyPlan.lunch.calories;
      protein += dailyPlan.lunch.nutrition.protein;
      carbs += dailyPlan.lunch.nutrition.carbs;
      fat += dailyPlan.lunch.nutrition.fat;
      
      return {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };
    } catch (e) {
      developer.log('Error calculating nutrition totals', name: 'MealPlanService', error: e.toString());
      return {
        'calories': 0,
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
      };
    }
  }
}
