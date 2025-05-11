import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../controllers/nutrition_controller.dart';

// Remove this function as we're only using regenerate now
// void showGeneratePlanDialog(...)

void showGeneratePlanDialog(BuildContext context, NutritionController controller, VoidCallback onSuccess) {
  HapticFeedback.mediumImpact();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Generate Meal Plan?', // Updated title
          style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'This will create a new meal plan based on your preferences. Any changes to your current plan will be lost.',
          style: TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await controller.generateMealPlan(); // Changed method call from regeneratePlan to generateMealPlan
              onSuccess();
              Get.snackbar(
                'Success',
                'Your meal plan has been generated!', // Updated message
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade800,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Generate', style: TextStyle(color: Colors.white)), // Updated button text
          ),
        ],
      );
    },
  );
}
