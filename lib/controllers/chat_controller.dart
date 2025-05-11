import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/fitness_advice_response.dart';

class ChatController extends GetxController {
  final uuid = const Uuid();
  // Make messages observable using RxList
  final messages = <types.Message>[].obs;
  final user = const types.User(id: '1', firstName: 'Ahmed');
  final String apiUrl = 'https://musclescoach.onrender.com/fitness-advice/';

  @override
  void onInit() {
    super.onInit();
    // Initialize with messages using update method
    addInitialMessages();
  }

  void addInitialMessages() {
    final initialMessages = [
      createMessage('Welcome to Fat2Fit! How can I help you today?', true),
      createMessage('Here to help you achieve your fitness goals!', true),
    ];
    messages.assignAll(initialMessages.reversed);
  }

  types.TextMessage createMessage(String text, bool isReceived) {
    return types.TextMessage(
      author:
          isReceived ? const types.User(id: '2', firstName: 'Assistant') : user,
      id: uuid.v4(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void addMessage(String text, bool isReceived) {
    final message = createMessage(text, isReceived);
    messages.insert(0, message);
  }

  Future<String> getFitnessAdvice(String query) async {
    // Encode the query parameter properly for URL
    final encodedQuery = Uri.encodeComponent(query);
    final requestUrl = '${apiUrl}?query=$encodedQuery';
    
    developer.log('Making API request to: $requestUrl', name: 'ChatController');
    
    try {
      final response = await http.post(
        Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 120), onTimeout: () {
        developer.log('API request timed out after 120 seconds', name: 'ChatController', error: 'Timeout');
        throw TimeoutException('Request timed out');
      });

      developer.log('Response status code: ${response.statusCode}', name: 'ChatController');
      developer.log('Response body: ${response.body}', name: 'ChatController');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          
          // Check if the response field exists directly
          if (jsonData.containsKey('response')) {
            developer.log('Found response field in API response', name: 'ChatController');
            return jsonData['response'];
          } 
          // Try using the model
          else {
            final adviceResponse = FitnessAdviceResponse.fromJson(jsonData);
            developer.log('Parsed response through model: ${adviceResponse.advice}', name: 'ChatController');
            return adviceResponse.advice.isNotEmpty 
                ? adviceResponse.advice 
                : 'Sorry, I couldn\'t get advice at the moment.';
          }
        } catch (e) {
          developer.log('Error parsing JSON response', name: 'ChatController', error: e.toString());
          return 'Sorry, I had trouble understanding the server response.';
        }
      } else {
        developer.log('API error: Non-200 status code', name: 'ChatController', error: response.body);
        return 'Sorry, I\'m having trouble connecting to the fitness advice service. Status: ${response.statusCode}';
      }
    } on FormatException catch (e) {
      developer.log('JSON parsing error', name: 'ChatController', error: e.toString());
      return 'Sorry, I received an invalid response from the server.';
    } on TimeoutException catch (e) {
      developer.log('Request timeout', name: 'ChatController', error: e.toString());
      return 'The server took too long to respond. Please try again later.';
    } catch (e) {
      developer.log('Network error', name: 'ChatController', error: e.toString());
      return 'Network error: Unable to connect to the fitness advice service. Please check your internet connection and try again.';
    }
  }

  void handleSendPressed(types.PartialText message) {
    final userMessage = message.text;
    addMessage(userMessage, false);
    
    // Show typing indicator
    addMessage('...', true);
    
    // Check if the message is a reset command
    if (userMessage.trim().toLowerCase() == 'reset') {
      // Call the fitness advice API with reset command
      getFitnessAdvice('reset').then((response) {
        // Remove typing indicator
        messages.removeWhere((msg) => 
          msg.author.id == '2' && (msg as types.TextMessage).text == '...');
        
        // Add the reset confirmation response
        addMessage(response, true);
        
        // Clear chat history except for the last reset message and initial messages
        Future.delayed(Duration(milliseconds: 500), () {
          resetChatHistory();
        });
      });
    } else {
      // Regular message handling
      getFitnessAdvice(userMessage).then((response) {
        // Remove typing indicator
        messages.removeWhere((msg) => 
          msg.author.id == '2' && (msg as types.TextMessage).text == '...');
        
        // Add the real response
        addMessage(response, true);
      });
    }
  }
  
  void resetChatHistory() {
    // Clear all messages
    messages.clear();
    
    // Re-add initial welcome messages
    addInitialMessages();
    
    // Add a visual confirmation
    addMessage("Chat history cleared. Let's start fresh!", true);
  }

  // Method to reset the chat that can be called directly from UI
  Future<void> resetChat() async {
    // Show typing indicator
    addMessage('...', true);
    
    // Call the fitness advice API with reset command
    final response = await getFitnessAdvice('reset');
    
    // Remove typing indicator
    messages.removeWhere((msg) => 
      msg.author.id == '2' && (msg as types.TextMessage).text == '...');
    
    // Add the reset confirmation response
    addMessage(response, true);
    
    // Clear chat history after a short delay
    await Future.delayed(Duration(milliseconds: 500));
    resetChatHistory();
    
    return;
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
