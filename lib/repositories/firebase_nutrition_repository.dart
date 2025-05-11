import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import '../models/nutrition_models.dart';
import '../models/detailed_meal_plan.dart';
import 'nutrition_repository.dart';

class FirebaseNutritionRepository implements NutritionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  FirebaseNutritionRepository({
    FirebaseFirestore? firestore, 
    FirebaseAuth? auth
  }) : 
    _firestore = firestore ?? FirebaseFirestore.instance,
    _auth = auth ?? FirebaseAuth.instance;

  /// Get current user email or throw an exception if not available
  String _getCurrentUserEmail() {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not logged in or email not available');
    }
    return user.email!;
  }
  
  @override
  Future<void> saveSessionId(String sessionId) async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      await _firestore
          .collection('nutrition_sessions')
          .doc(userEmail)
          .set({
            'sessionId': sessionId,
            'userId': _auth.currentUser!.uid,
            'email': userEmail,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp()
          });
      
      developer.log('Saved session ID: $sessionId for email: $userEmail', name: 'FirebaseNutritionRepository');
    } catch (e) {
      developer.log('Error saving session ID', name: 'FirebaseNutritionRepository', error: e.toString());
      rethrow;
    }
  }
  
  @override
  Future<String?> loadSessionId() async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      final doc = await _firestore
          .collection('nutrition_sessions')
          .doc(userEmail)
          .get();
      
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('sessionId')) {
        final sessionId = doc.data()!['sessionId'] as String;
        developer.log('Loaded session ID: $sessionId for email: $userEmail', name: 'FirebaseNutritionRepository');
        return sessionId;
      }
      
      developer.log('No session ID found in Firebase for email: $userEmail', name: 'FirebaseNutritionRepository');
      return null;
    } catch (e) {
      developer.log('Error loading session ID', name: 'FirebaseNutritionRepository', error: e.toString());
      rethrow;
    }
  }
  
  @override
  Future<bool> saveUserInfo(UserInfoRequest userInfo) async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      await _firestore
          .collection('users')
          .doc(userEmail)
          .set({
            'userId': _auth.currentUser!.uid,
            'email': userEmail,
            'language': userInfo.language,
            'foodType': userInfo.foodType,
            'weight': userInfo.weight,
            'height': userInfo.height,
            'age': userInfo.age,
            'gender': userInfo.gender,
            'activityLevel': userInfo.activityLevel,
            'bodyShapeGoal': userInfo.bodyShapeGoal,
            'updatedAt': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      
      developer.log('Saved user info for email: $userEmail', name: 'FirebaseNutritionRepository');
      return true;
    } catch (e) {
      developer.log('Error saving user info', name: 'FirebaseNutritionRepository', error: e.toString());
      return false;
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      final doc = await _firestore.collection('users').doc(userEmail).get();
      if (doc.exists && doc.data() != null) {
        return doc.data();
      }
      return null;
    } catch (e) {
      developer.log('Error retrieving user info', name: 'FirebaseNutritionRepository', error: e.toString());
      return null;
    }
  }
  
  @override
  Future<void> saveMealRatings(Map<String, int> ratings) async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      await _firestore
          .collection('meal_ratings')
          .doc(userEmail)
          .set({
            'ratings': ratings,
            'userId': _auth.currentUser!.uid,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      
      developer.log('Saved meal ratings for email: $userEmail', name: 'FirebaseNutritionRepository');
    } catch (e) {
      developer.log('Error saving meal ratings', name: 'FirebaseNutritionRepository', error: e.toString());
      rethrow;
    }
  }

  @override
  Future<void> saveMealPlan(DetailedWeeklyPlan plan) async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      // Convert the meal plan to a serializable map
      // We need to handle this manually since the model might not have toJson methods
      final Map<String, dynamic> planData = {
        'weeklyPlan': plan.weeklyPlan.map((dailyPlan) {
          return {
            'day': dailyPlan.day,
            'breakfast': {
              'id': dailyPlan.breakfast.id, // Added id
              'name': dailyPlan.breakfast.name,
              'recipe': dailyPlan.breakfast.recipe,
              'calories': dailyPlan.breakfast.calories,
              'servingSize': dailyPlan.breakfast.servingSize, // Added servingSize
              'nutrition': {
                'protein': dailyPlan.breakfast.nutrition.protein,
                'carbs': dailyPlan.breakfast.nutrition.carbs,
                'fat': dailyPlan.breakfast.nutrition.fat,
              }
            },
            'lunch': {
              'id': dailyPlan.lunch.id, // Added id
              'name': dailyPlan.lunch.name,
              'recipe': dailyPlan.lunch.recipe,
              'calories': dailyPlan.lunch.calories,
              'servingSize': dailyPlan.lunch.servingSize, // Added servingSize
              'nutrition': {
                'protein': dailyPlan.lunch.nutrition.protein,
                'carbs': dailyPlan.lunch.nutrition.carbs,
                'fat': dailyPlan.lunch.nutrition.fat,
              }
            },
            'snack': {
              'id': dailyPlan.snack.id, // Added id
              'name': dailyPlan.snack.name,
              'recipe': dailyPlan.snack.recipe,
              'calories': dailyPlan.snack.calories,
              'servingSize': dailyPlan.snack.servingSize, // Added servingSize
              'nutrition': {
                'protein': dailyPlan.snack.nutrition.protein,
                'carbs': dailyPlan.snack.nutrition.carbs,
                'fat': dailyPlan.snack.nutrition.fat,
              }
            },
          };
        }).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Save to Firestore
      await _firestore
          .collection('meal_plans')
          .doc(userEmail)
          .set(planData, SetOptions(merge: true));
      
      developer.log('Meal plan saved to Firestore for $userEmail', name: 'FirebaseNutritionRepository');
    } catch (e) {
      developer.log('Error saving meal plan', name: 'FirebaseNutritionRepository', error: e.toString());
      rethrow;
    }
  }
  
  @override
  Future<DetailedWeeklyPlan?> loadMealPlan() async {
    try {
      final userEmail = _getCurrentUserEmail();
      
      final doc = await _firestore.collection('meal_plans').doc(userEmail).get();
      
      if (!doc.exists || doc.data() == null) {
        developer.log('No meal plan found for $userEmail', name: 'FirebaseNutritionRepository');
        return null;
      }
      
      final data = doc.data()!;
      
      // Convert Firestore data back to DetailedWeeklyPlan
      final List<dynamic> weeklyPlanData = data['weeklyPlan'] as List<dynamic>;
      
      final List<DailyMealPlan> weeklyPlan = weeklyPlanData.map((dayData) {
        final Map<String, dynamic> day = dayData as Map<String, dynamic>;
        
        // Parse breakfast
        final breakfastData = day['breakfast'] as Map<String, dynamic>;
        final breakfastNutrition = breakfastData['nutrition'] as Map<String, dynamic>;
        
        final breakfast = MealDetail(
          id: breakfastData['id'] ?? 'breakfast_${day['day']}', // Added id with fallback
          name: breakfastData['name'],
          recipe: breakfastData['recipe'],
          calories: breakfastData['calories'],
          servingSize: breakfastData['servingSize'] ?? '1 portion', // Added servingSize with fallback
          nutrition: NutritionInfo(
            protein: breakfastNutrition['protein'],
            carbs: breakfastNutrition['carbs'],
            fat: breakfastNutrition['fat'],
          ),
        );
        
        // Parse lunch
        final lunchData = day['lunch'] as Map<String, dynamic>;
        final lunchNutrition = lunchData['nutrition'] as Map<String, dynamic>;
        
        final lunch = MealDetail(
          id: lunchData['id'] ?? 'lunch_${day['day']}', // Added id with fallback
          name: lunchData['name'],
          recipe: lunchData['recipe'],
          calories: lunchData['calories'],
          servingSize: lunchData['servingSize'] ?? '1 portion', // Added servingSize with fallback
          nutrition: NutritionInfo(
            protein: lunchNutrition['protein'],
            carbs: lunchNutrition['carbs'],
            fat: lunchNutrition['fat'],
          ),
        );
        
        // Parse snack
        final snackData = day['snack'] as Map<String, dynamic>;
        final snackNutrition = snackData['nutrition'] as Map<String, dynamic>;
        
        final snack = MealDetail(
          id: snackData['id'] ?? 'snack_${day['day']}', // Added id with fallback
          name: snackData['name'],
          recipe: snackData['recipe'],
          calories: snackData['calories'],
          servingSize: snackData['servingSize'] ?? '1 portion', // Added servingSize with fallback
          nutrition: NutritionInfo(
            protein: snackNutrition['protein'],
            carbs: snackNutrition['carbs'],
            fat: snackNutrition['fat'],
          ),
        );
        
        return DailyMealPlan(
          day: day['day'],
          breakfast: breakfast,
          lunch: lunch,
          snack: snack,
        );
      }).toList();
      
      developer.log('Meal plan loaded from Firestore for $userEmail', name: 'FirebaseNutritionRepository');
      return DetailedWeeklyPlan(weeklyPlan: weeklyPlan);
    } catch (e) {
      developer.log('Error loading meal plan', name: 'FirebaseNutritionRepository', error: e.toString());
      return null;
    }
  }
}
