import 'dart:convert';
import 'meal.dart';

class DetailedWeeklyPlan {
  final List<DailyMealPlan> weeklyPlan;
  
  DetailedWeeklyPlan({required this.weeklyPlan});
  
  factory DetailedWeeklyPlan.fromJson(Map<String, dynamic> json) {
    final List<dynamic> weeklyPlanJson = json['weekly_plan'] as List;
    return DetailedWeeklyPlan(
      weeklyPlan: weeklyPlanJson
          .map((dayPlan) => DailyMealPlan.fromJson(dayPlan))
          .toList(),
    );
  }
}

class DailyMealPlan {
  final String day;
  final MealDetail breakfast;
  final MealDetail snack;
  final MealDetail lunch;
  
  DailyMealPlan({
    required this.day,
    required this.breakfast,
    required this.snack,
    required this.lunch,
  });
  
  factory DailyMealPlan.fromJson(Map<String, dynamic> json) {
    return DailyMealPlan(
      day: json['day'],
      breakfast: MealDetail.fromJson(json['breakfast']),
      snack: MealDetail.fromJson(json['snack']),
      lunch: MealDetail.fromJson(json['lunch']),
    );
  }
}

class MealDetail {
  final String id;
  final String name;
  final int calories;
  final NutritionInfo nutrition;
  final String servingSize;
  final String? breadSuggestion;
  final String recipe;
  
  MealDetail({
    required this.id,
    required this.name,
    required this.calories,
    required this.nutrition,
    required this.servingSize,
    this.breadSuggestion,
    required this.recipe,
  });
  
  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      nutrition: NutritionInfo.fromJson(json['nutrition']),
      servingSize: json['serving_size'],
      breadSuggestion: json['bread_suggestion'],
      recipe: json['recipe'],
    );
  }
}

class NutritionInfo {
  final double protein;
  final double carbs;
  final double fat;
  
  NutritionInfo({
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
    );
  }
}

class DetailedMealPlan {
  final List<Meal> meals;
  final String day;
  
  DetailedMealPlan({
    required this.meals,
    required this.day,
  });
  
  factory DetailedMealPlan.fromJson(Map<String, dynamic> json) {
    List<Meal> mealsList = [];
    if (json['meals'] != null) {
      mealsList = (json['meals'] as List)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList();
    }
    
    return DetailedMealPlan(
      meals: mealsList,
      day: json['day'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'meals': meals.map((meal) => meal.toJson()).toList(),
      'day': day,
    };
  }
}