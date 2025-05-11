import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nutrition_models.dart';
import '../models/detailed_meal_plan.dart';

abstract class NutritionRepository {
  /// Save session ID for the current user
  Future<void> saveSessionId(String sessionId);
  
  /// Load session ID for the current user
  Future<String?> loadSessionId();
  
  /// Save user nutrition information 
  Future<bool> saveUserInfo(UserInfoRequest userInfo);
  
  /// Get user nutrition information
  Future<Map<String, dynamic>?> getUserInfo();
  
  /// Save meal ratings
  Future<void> saveMealRatings(Map<String, int> ratings);
  
  /// Save meal plan to Firestore
  Future<void> saveMealPlan(DetailedWeeklyPlan plan);
  
  /// Load meal plan from Firestore
  Future<DetailedWeeklyPlan?> loadMealPlan();
}
