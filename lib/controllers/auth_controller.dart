import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Observable variables
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  
  // Auth status
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  User? get user => _firebaseUser.value;
  bool get isLoggedIn => user != null;
  
  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
  }
  
  // Login with email and password
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      debugPrint('Attempting to login with email: $email');
      
      // Trim email and password to remove any accidental spaces
      email = email.trim();
      
      // Perform validation before sending to Firebase
      if (email.isEmpty) {
        error.value = 'Email cannot be empty';
        isLoading.value = false;
        return false;
      }
      
      if (password.isEmpty) {
        error.value = 'Password cannot be empty';
        isLoading.value = false;
        return false;
      }
      
      // Try to authenticate
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Login successful for email: $email');
      isLoading.value = false;
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      debugPrint('Firebase Auth Exception during login: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'user-not-found':
          error.value = 'No user found with this email.';
          break;
        case 'wrong-password':
          error.value = 'Wrong password provided.';
          break;
        case 'invalid-email':
          error.value = 'The email address is invalid.';
          break;
        case 'user-disabled':
          error.value = 'This account has been disabled.';
          break;
        case 'invalid-credential':
          error.value = 'Invalid email or password. Please check your credentials and try again.';
          break;
        case 'too-many-requests':
          error.value = 'Too many login attempts. Please try again later.';
          break;
        case 'network-request-failed':
          error.value = 'Network error. Please check your connection.';
          break;
        default:
          error.value = 'An error occurred: ${e.message}';
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      debugPrint('Unexpected error during login: $e');
      error.value = 'An unexpected error occurred: $e';
      return false;
    }
  }
  
  // Sign up with email and password
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Trim email to remove any accidental spaces
      email = email.trim();
      
      debugPrint('Attempting to create account with email: $email');
      
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Account creation successful for email: $email');
      isLoading.value = false;
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      debugPrint('Firebase Auth Exception during signup: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'email-already-in-use':
          error.value = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          error.value = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          error.value = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          error.value = 'The password is too weak.';
          break;
        case 'invalid-credential':
          error.value = 'Invalid email or password format.';
          break;
        default:
          error.value = 'An error occurred during sign up: ${e.message}';
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      debugPrint('Unexpected error during signup: $e');
      error.value = 'An unexpected error occurred during sign up.';
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      error.value = 'Error signing out: ${e.toString()}';
    }
  }
}