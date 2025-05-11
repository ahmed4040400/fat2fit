import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoadingDebugger {
  static void monitorLoadingState(RxBool loadingState, String name) {
    // Only activate in debug mode
    if (!kDebugMode) return;
    
    ever(loadingState, (bool isLoading) {
      log('[$name] Loading state: $isLoading', name: 'LoadingDebugger');
      
      // Track loading times to detect hanging loading states
      if (isLoading) {
        _startLoadingTimer(loadingState, name);
      }
    });
  }
  
  static void _startLoadingTimer(RxBool loadingState, String name) {
    Future.delayed(const Duration(seconds: 20), () {
      if (loadingState.value) {
        log('⚠️ [$name] Loading has been active for 20 seconds! Might be stuck.',
            name: 'LoadingDebugger');
      }
    });
  }
  
  static void safeSetLoading(RxBool loadingState, bool value, {String? context}) {
    if (loadingState.value != value) {
      if (kDebugMode) {
        log('Setting loading to $value ${context != null ? "($context)" : ""}',
            name: 'LoadingDebugger');
      }
      loadingState.value = value;
    }
  }
}
