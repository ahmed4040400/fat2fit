import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_models.dart';
import '../models/detailed_meal_plan.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class NutritionService {
  static const String baseUrl = 'https://nutrition-plan-recommendation-system.onrender.com';
  
  // Submit user information and get session ID
  Future<SessionResponse> setUserInfo(UserInfoRequest userInfo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/set_user_info'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userInfo.toJson()),
      );

      developer.log('Set User Info response: ${response.statusCode} - ${response.body}', 
          name: 'NutritionService');

      if (response.statusCode == 200) {
        // Properly decode UTF-8 response for Arabic support
        final decodedBody = _decodeUtf8Response(response.body);
        return SessionResponse.fromJson(decodedBody);
      } else {
        throw Exception('Failed to set user info. Status: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in setUserInfo: $e', name: 'NutritionService');
      rethrow;
    }
  }

  // Get meal plan using session ID
  Future<DetailedWeeklyPlan> generatePlan(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/generate_plan?session_id=$sessionId'),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      developer.log('Generate Plan response: ${response.statusCode}', 
          name: 'NutritionService');
      
      if (kDebugMode) {
        developer.log('Response body sample (first 200 chars): ${response.body.substring(0, min(200, response.body.length))}',
            name: 'NutritionService');
      }

      if (response.statusCode == 200) {
        // Properly decode UTF-8 response for Arabic support
        final decodedBody = _decodeUtf8Response(response.body);
        return DetailedWeeklyPlan.fromJson(decodedBody);
      } else {
        throw Exception('Failed to generate meal plan. Status: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in generatePlan: $e', name: 'NutritionService');
      rethrow;
    }
  }

  // Submit feedback about the plan
  Future<FeedbackResponse> submitPlanFeedback(String sessionId, String feedback) async {
    try {
      final request = FeedbackRequest(sessionId: sessionId, feedback: feedback);
      
      final response = await http.post(
        Uri.parse('$baseUrl/plan_feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      developer.log('Plan Feedback response: ${response.statusCode} - ${response.body}', 
          name: 'NutritionService');

      if (response.statusCode == 200) {
        // Properly decode UTF-8 response for Arabic support
        final decodedBody = _decodeUtf8Response(response.body);
        return FeedbackResponse.fromJson(decodedBody);
      } else {
        throw Exception('Failed to submit feedback. Status: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in submitPlanFeedback: $e', name: 'NutritionService');
      rethrow;
    }
  }

  // Submit meal ratings
  Future<FeedbackResponse> submitMealRatings(String sessionId, Map<String, int> ratings) async {
    try {
      final request = MealRatings(sessionId: sessionId, ratings: ratings);
      
      final response = await http.post(
        Uri.parse('$baseUrl/submit_ratings'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      developer.log('Submit Ratings response: ${response.statusCode} - ${response.body}', 
          name: 'NutritionService');

      if (response.statusCode == 200) {
        // Properly decode UTF-8 response for Arabic support
        final decodedBody = _decodeUtf8Response(response.body);
        return FeedbackResponse.fromJson(decodedBody);
      } else {
        throw Exception('Failed to submit ratings. Status: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in submitMealRatings: $e', name: 'NutritionService');
      rethrow;
    }
  }

  // Regenerate plan based on ratings
  Future<DetailedWeeklyPlan> regeneratePlan(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/regenerate_plan?session_id=$sessionId'),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      developer.log('Regenerate Plan response: ${response.statusCode}', 
          name: 'NutritionService');
      
      if (kDebugMode) {
        developer.log('Response body sample (first 200 chars): ${response.body.substring(0, min(200, response.body.length))}',
            name: 'NutritionService');
      }

      if (response.statusCode == 200) {
        // Properly decode UTF-8 response for Arabic support
        final decodedBody = _decodeUtf8Response(response.body);
        return DetailedWeeklyPlan.fromJson(decodedBody);
      } else {
        throw Exception('Failed to regenerate meal plan. Status: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in regeneratePlan: $e', name: 'NutritionService');
      rethrow;
    }
  }
  
  // Helper method to properly decode UTF-8 responses (important for Arabic)
  dynamic _decodeUtf8Response(String responseBody) {
    try {
      // First, check if the responseBody is valid JSON
      if (responseBody.trim().startsWith('{') || responseBody.trim().startsWith('[')) {
        // Try to decode as UTF-8 to handle Arabic characters properly
        final decoded = json.decode(utf8.decode(responseBody.codeUnits));
        
        // Log the first part of the decoded response for debugging
        if (kDebugMode && decoded is Map && decoded.containsKey('weeklyPlan')) {
          final firstMeal = decoded['weeklyPlan'][0]['breakfast']['name'];
          developer.log('First meal name decoded: $firstMeal', name: 'NutritionService');
        }
        
        return decoded;
      } else {
        developer.log('Response body is not valid JSON: $responseBody', name: 'NutritionService');
        throw FormatException('Response was not valid JSON');
      }
    } catch (e) {
      developer.log('Error decoding UTF-8 response: $e', name: 'NutritionService');
      // Fallback to regular JSON decoding
      return json.decode(responseBody);
    }
  }
  
  // Helper method to get the minimum of two numbers
  int min(int a, int b) => a < b ? a : b;
}