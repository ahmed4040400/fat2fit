import 'package:flutter/material.dart';

class EnhancedFeedbackButton extends StatelessWidget {
  final String label;
  final String feedback;
  final bool isPositive;
  final VoidCallback onPressed;

  const EnhancedFeedbackButton({
    Key? key,
    required this.label,
    required this.feedback,
    required this.isPositive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: isPositive ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return isPositive 
                      ? const Color(0xFF1B5E20) 
                      : Colors.grey.shade400;
                }
                return isPositive 
                    ? const Color(0xFF2E7D32) 
                    : Colors.grey.shade200;
              },
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
