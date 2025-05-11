import 'dart:convert';

// User info request model
class UserInfoRequest {
  final String language;
  final String foodType;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;
  final String bodyShapeGoal; // Changed from desiredBodyShape to bodyShapeGoal

  UserInfoRequest({
    required this.language,
    required this.foodType,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.bodyShapeGoal, // Changed parameter name
  });

  Map<String, dynamic> toJson() => {
        'language': language.toLowerCase(), // Ensure language is lowercase
        'food_type': foodType.toLowerCase(),
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender.toLowerCase(),
        'activity_level': activityLevel.toLowerCase(),
        'body_shape_goal': bodyShapeGoal.toLowerCase(), // Changed to body_shape_goal
      };
}

// Session response model
class SessionResponse {
  final String sessionId;

  SessionResponse({required this.sessionId});

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      sessionId: json['session_id'],
    );
  }
}

// Meal model
class Meal {
  final String breakfast;
  final String lunch;
  final String dinner;

  Meal({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      breakfast: json['breakfast'] ?? '',
      lunch: json['lunch'] ?? '',
      dinner: json['dinner'] ?? '',
    );
  }
}

// Weekly meal plan model
class WeeklyMealPlan {
  final Map<String, Meal> weekPlan;

  WeeklyMealPlan({required this.weekPlan});

  factory WeeklyMealPlan.fromJson(Map<String, dynamic> json) {
    final planData = json['week_plan'] as Map<String, dynamic>;
    final Map<String, Meal> plan = {};

    planData.forEach((key, value) {
      plan[key] = Meal.fromJson(value);
    });

    return WeeklyMealPlan(weekPlan: plan);
  }
}

// Feedback request model
class FeedbackRequest {
  final String sessionId;
  final String feedback;

  FeedbackRequest({
    required this.sessionId,
    required this.feedback,
  });

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'feedback': feedback,
      };
}

// Feedback response model
class FeedbackResponse {
  final String message;

  FeedbackResponse({required this.message});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      message: json['message'],
    );
  }
}

// Meal ratings model
class MealRatings {
  final Map<String, int> ratings;
  final String sessionId;

  MealRatings({
    required this.sessionId,
    required this.ratings,
  });

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'ratings': ratings,
      };
}