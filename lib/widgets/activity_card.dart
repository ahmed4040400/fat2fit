import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ActivityCard extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color? color;
  final String? lottieUrl;

  const ActivityCard({
    Key? key,
    required this.label,
    this.value,
    required this.icon,
    this.color,
    this.lottieUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1) ?? Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color?.withOpacity(0.3) ?? Colors.green.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color ?? Colors.green,
                size: 24,
              ),
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(
                    color: color ?? Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (lottieUrl != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: Center(
                child: Lottie.network(
                  lottieUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      icon,
                      color: color ?? Colors.green,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
