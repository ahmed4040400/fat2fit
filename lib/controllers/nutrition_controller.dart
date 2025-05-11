import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

import '../models/nutrition_models.dart';
import '../models/detailed_meal_plan.dart';
import '../repositories/nutrition_repository.dart';
import '../repositories/firebase_nutrition_repository.dart';
import '../services/meal_plan_service.dart';
import '../services/user_nutrition_service.dart';

class NutritionController extends GetxController {
  // Dependencies
  final NutritionRepository _repository;
  final MealPlanService _mealPlanService;
  final UserNutritionService _userService;
  
  // Observable states
  final RxString sessionId = ''.obs;
  final Rx<DetailedWeeklyPlan?> detailedMealPlan = Rx<DetailedWeeklyPlan?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString feedbackMessage = ''.obs;
  final RxBool showRatingForm = false.obs;
  
  // Meal ratings
  final RxMap<String, int> mealRatings = <String, int>{}.obs;
  
  // UI state
  final RxString selectedDay = 'Monday'.obs;
  final List<String> weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
    'Friday', 'Saturday', 'Sunday'
  ];
  
  // Nutrition totals
  final RxInt totalCalories = 0.obs;
  final RxDouble totalProtein = 0.0.obs;
  final RxDouble totalCarbs = 0.0.obs;
  final RxDouble totalFat = 0.0.obs;

  NutritionController({
    NutritionRepository? repository,
    MealPlanService? mealPlanService,
    UserNutritionService? userService
  }) : 
    _repository = repository ?? FirebaseNutritionRepository(),
    _mealPlanService = mealPlanService ?? MealPlanService(),
    _userService = userService ?? UserNutritionService(
      repository: FirebaseNutritionRepository()
    );

  @override
  void onInit() {
    super.onInit();
    loadSessionId();
    ever(selectedDay, (_) => updateNutritionTotals());
    Future.delayed(const Duration(seconds: 10), checkAndFixLoadingState);
  }

  // Load session ID from repository and then initialize the meal plan
  Future<void> loadSessionId() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final id = await _userService.loadSessionId();
      
      if (id != null && id.isNotEmpty) {
        sessionId.value = id;
        developer.log('Loaded session ID: ${sessionId.value}', name: 'NutritionController');
        
        // Try to load an existing meal plan from Firestore first
        await loadMealPlanFromFirestore();
      }
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error loading session ID', e);
    }
  }

  // New method to load meal plan from Firestore
  Future<void> loadMealPlanFromFirestore() async {
    try {
      // Only set loading if it's not already loading
      if (!isLoading.value) {
        isLoading.value = true;
      }
      
      errorMessage.value = '';
      
      if (sessionId.value.isEmpty) {
        developer.log('No session ID available, trying to load one first', name: 'NutritionController');
        final id = await _userService.loadSessionId();
        if (id != null && id.isNotEmpty) {
          sessionId.value = id;
        } else {
          errorMessage.value = 'No session ID available';
          isLoading.value = false;
          return;
        }
      }
      
      // Try to load from Firestore
      developer.log('Loading meal plan from Firestore', name: 'NutritionController');
      final storedPlan = await _repository.loadMealPlan();
      
      if (storedPlan != null) {
        developer.log('✅ Successfully loaded meal plan from Firestore', name: 'NutritionController');
        detailedMealPlan.value = storedPlan;
        updateNutritionTotals();
      } else {
        // If no plan in Firestore, generate a new one and save it
        developer.log('No meal plan in Firestore, generating new plan', name: 'NutritionController');
        await generateMealPlan();
      }
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error loading meal plan from Firestore', e);
    }
  }

  // Set user information and get session ID
  Future<bool> setUserInfo(UserInfoRequest userInfo) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final newSessionId = await _userService.setUserInfo(userInfo);
      
      // Check if the controller is still active before updating observables
      // This helps prevent unnecessary UI updates after screen disposal
      if (Get.isRegistered<NutritionController>()) {
        sessionId.value = newSessionId;
        isLoading.value = false;
      }
      
      return true;
    } catch (e) {
      _handleError('Error setting user info', e);
      return false;
    }
  }

  // Modified to save plan to Firestore
  Future<void> generateMealPlan() async {
    try {
      if (sessionId.value.isEmpty) {
        errorMessage.value = 'No session ID available';
        return;
      }
      
      isLoading.value = true;
      errorMessage.value = '';
      
      final plan = await _mealPlanService.generatePlan(sessionId.value);
      detailedMealPlan.value = plan;
      
      // Save the plan to Firestore
      await _repository.saveMealPlan(plan);
      
      updateNutritionTotals();
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error generating meal plan', e);
    }
  }

  // Update nutrition totals for the selected day
  void updateNutritionTotals() {
    if (detailedMealPlan.value == null) return;
    
    final selectedDayPlan = getSelectedDayMealPlan();
    if (selectedDayPlan == null) return;
    
    final nutritionTotals = _mealPlanService.calculateDailyNutrition(selectedDayPlan);
    
    totalCalories.value = nutritionTotals['calories'];
    totalProtein.value = nutritionTotals['protein'];
    totalCarbs.value = nutritionTotals['carbs'];
    totalFat.value = nutritionTotals['fat'];
  }

  // Submit feedback about plan
  Future<void> submitFeedback(String feedback) async {
    try {
      if (sessionId.value.isEmpty) {
        errorMessage.value = 'No session ID available';
        return;
      }
      
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _mealPlanService.submitPlanFeedback(sessionId.value, feedback);
      feedbackMessage.value = response.message;
      
      showRatingForm.value = feedback.toLowerCase() == 'no';
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error submitting feedback', e);
    }
  }

  // Set rating for specific meal
  void setMealRating(String day, String mealType, int rating) {
    final key = '${day}_${mealType.toLowerCase()}';
    mealRatings[key] = rating;
  }

  // Submit meal ratings
  Future<void> submitRatings() async {
    try {
      if (sessionId.value.isEmpty) {
        errorMessage.value = 'No session ID available';
        return;
      }
      
      if (mealRatings.isEmpty) {
        errorMessage.value = 'Please rate at least one meal';
        return;
      }
      
      isLoading.value = true;
      errorMessage.value = '';
      
      // Save ratings to Firebase
      await _repository.saveMealRatings(mealRatings);
      
      // Submit to API
      final response = await _mealPlanService.submitMealRatings(
        sessionId.value, 
        mealRatings
      );
      
      feedbackMessage.value = response.message;
      showRatingForm.value = false;
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error submitting ratings', e);
    }
  }

  // Modified to update Firestore when regenerating plan
  Future<void> regeneratePlan() async {
    try {
      if (sessionId.value.isEmpty) {
        errorMessage.value = 'No session ID available';
        return;
      }
      
      isLoading.value = true;
      errorMessage.value = '';
      
      final plan = await _mealPlanService.regeneratePlan(sessionId.value);
      detailedMealPlan.value = plan;
      
      // Save the regenerated plan to Firestore
      await _repository.saveMealPlan(plan);
      
      updateNutritionTotals();
      mealRatings.clear();
      
      isLoading.value = false;
    } catch (e) {
      _handleError('Error regenerating meal plan', e);
    }
  }
  
  // Change selected day
  void changeSelectedDay(String day) {
    selectedDay.value = day;
  }
  
  // Get meal plan for selected day
  DailyMealPlan? getSelectedDayMealPlan() {
    if (detailedMealPlan.value == null) return null;
    
    try {
      return detailedMealPlan.value!.weeklyPlan.firstWhere(
        (dailyPlan) => dailyPlan.day == selectedDay.value
      );
    } catch (e) {
      developer.log('Day not found: ${selectedDay.value}', name: 'NutritionController');
      return null;
    }
  }

  // Convert DailyMealPlan to DetailedMealPlan
  DetailedMealPlan getCurrentDayPlan(String day) {
    if (detailedMealPlan.value != null) {
      try {
        DailyMealPlan? dayPlan = detailedMealPlan.value!.weeklyPlan.firstWhere(
          (dailyPlan) => dailyPlan.day.toLowerCase() == day.toLowerCase(),
          orElse: () => detailedMealPlan.value!.weeklyPlan.first,
        );

        return _mealPlanService.convertDailyPlanToAppFormat(dayPlan);
      } catch (e) {
        developer.log('Error converting meal plan for day: $day', 
            name: 'NutritionController', error: e.toString());
      }
    }
    
    return DetailedMealPlan(meals: [], day: day);
  }

  void ratePlan(int rating) {
    submitFeedback(rating >= 3 ? "yes" : "no");
  }

  // Safely end the loading state
  void endLoading() {
    debugPrint('Explicitly ending loading state');
    isLoading.value = false;
  }

  // Diagnose and fix loading issues
  void checkAndFixLoadingState() {
    if (isLoading.value) {
      debugPrint('⚠️ Detected stuck loading state - clearing it');
      isLoading.value = false;
    }
  }

  // Retrieve user info from repository
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      return await _userService.getUserInfo();
    } catch (e) {
      _handleError('Error retrieving user info', e);
      return null;
    }
  }
  
  // Centralized error handling
  void _handleError(String context, dynamic error) {
    // Only update observable values if the controller is still registered
    if (Get.isRegistered<NutritionController>()) {
      isLoading.value = false;
      errorMessage.value = '$context: ${error.toString()}';
    }
    
    developer.log(context, name: 'NutritionController', error: error.toString());
  }
  
  // Add a new method to safely update observables
  void safeUpdateObservable<T>(Rx<T> observable, T value) {
    if (Get.isRegistered<NutritionController>()) {
      observable.value = value;
    }
  }
  
  // Call this when screen is disposed to prevent updating UI
  void onScreenDisposed() {
    developer.log('Screen disposed, preventing further UI updates', name: 'NutritionController');
  }
}