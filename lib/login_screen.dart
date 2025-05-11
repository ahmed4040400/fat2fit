import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:fat2fit/controllers/auth_controller.dart';
import 'package:fat2fit/controllers/nutrition_controller.dart'; // Add import for NutritionController
import 'more_info_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    final AuthController authController = Get.find<AuthController>();
    
    debugPrint('Login attempt with email: ${data.name}');
    
    bool success = await authController.loginWithEmailAndPassword(
      data.name, 
      data.password
    );
    
    if (success) {
      debugPrint('Login successful');
      return null; // null means no error
    } else {
      debugPrint('Login failed: ${authController.error.value}');
      return authController.error.value;
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    final AuthController authController = Get.find<AuthController>();
    
    debugPrint('Signup attempt with email: ${data.name}');
    
    if (data.name == null || data.password == null) {
      debugPrint('Signup failed: email or password is null');
      return 'Email and password cannot be empty';
    }
    
    bool success = await authController.signUpWithEmailAndPassword(
      data.name!, 
      data.password!
    );
    
    if (success) {
      debugPrint('Signup successful');
      return null; // null means no error
    } else {
      debugPrint('Signup failed: ${authController.error.value}');
      return authController.error.value;
    }
  }

  // New method to check if user has completed profile setup
  Future<void> _checkUserInfoAndNavigate() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      
      final nutritionController = Get.find<NutritionController>();
      final userInfo = await nutritionController.getUserInfo();
      
      // Close loading indicator
      Get.back();
      
      if (userInfo != null && 
          userInfo['weight'] != null && 
          userInfo['height'] != null && 
          userInfo['age'] != null) {
        // User has completed profile data, navigate to home screen
        debugPrint('User profile data found, navigating to home screen');
        Get.offNamed('/home_page');
      } else {
        // User needs to provide more info
        debugPrint('User profile data not found, navigating to more info screen');
        Get.offNamed('/home');
      }
    } catch (e) {
      // Close loading indicator if showing
      if (Get.isDialogOpen == true) Get.back();
      
      // Error occurred, default to more info screen
      debugPrint('Error checking user info: $e');
      Get.offNamed('/home');
      
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to load profile data. Please complete your profile.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'Fat2Fit',
        hideForgotPasswordButton: true,
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          // Replace direct navigation with profile check
          _checkUserInfoAndNavigate();
        },
        onRecoverPassword: (String name) {
          debugPrint('Password recovery requested for: $name');
          return Future.value('Password recovery not implemented');
        },
        theme: LoginTheme(
          primaryColor: Colors.green, // Set background color to green
          titleStyle: const TextStyle(
            color: Colors.white,
          ), // Set title color to white
        ),
      ),
    );
  }
}