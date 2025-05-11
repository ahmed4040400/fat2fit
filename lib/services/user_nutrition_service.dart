import 'dart:developer' as developer;

import '../models/nutrition_models.dart';
import '../repositories/nutrition_repository.dart';
import '../services/nutrition_service.dart';

class UserNutritionService {
  final NutritionRepository _repository;
  final NutritionService _nutritionService;
  
  UserNutritionService({
    required NutritionRepository repository,
    NutritionService? nutritionService
  }) : 
    _repository = repository,
    _nutritionService = nutritionService ?? NutritionService();
  
  /// Set user information and obtain a session ID
  Future<String> setUserInfo(UserInfoRequest userInfo) async {
    try {
      // Save user info to repository
      final saved = await _repository.saveUserInfo(userInfo);
      
      if (!saved) {
        throw Exception('Failed to save user information');
      }
      
      // Get session ID from API
      final response = await _nutritionService.setUserInfo(userInfo);
      
      // Save session ID to repository
      await _repository.saveSessionId(response.sessionId);
      
      return response.sessionId;
    } catch (e) {
      developer.log('Error setting user info', name: 'UserNutritionService', error: e.toString());
      rethrow;
    }
  }
  
  /// Load existing session ID from repository
  Future<String?> loadSessionId() async {
    try {
      return await _repository.loadSessionId();
    } catch (e) {
      developer.log('Error loading session ID', name: 'UserNutritionService', error: e.toString());
      rethrow;
    }
  }
  
  /// Get user information from repository
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      return await _repository.getUserInfo();
    } catch (e) {
      developer.log('Error getting user info', name: 'UserNutritionService', error: e.toString());
      return null;
    }
  }
}
