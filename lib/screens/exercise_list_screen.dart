import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/exercise_api_controller.dart';
import '../models/exercise_model.dart';

class ExerciseListScreen extends GetView<ExerciseApiController> {
  final String muscleType;

  ExerciseListScreen({required this.muscleType}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshExercises(muscleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${muscleType} Exercises'), centerTitle: true),
      body: Obx(() {
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.exercises.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.exercises.length,
          itemBuilder: (context, index) {
            final exercise = controller.exercises[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ExerciseCard(exercise: exercise),
            );
          },
        );
      }),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                exercise.gifUrl,
                fit:
                    BoxFit
                        .contain, // Changed from BoxFit.cover to BoxFit.contain
                width: double.infinity,
                height: 200,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Target Muscle:', exercise.target),
                _buildInfoRow('Body Part:', exercise.bodyPart),
                _buildInfoRow('Equipment:', exercise.equipment),
                if (exercise.secondaryMuscles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Secondary Muscles:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(exercise.secondaryMuscles.join(', ')),
                ],
                if (exercise.instructions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...exercise.instructions.map(
                    (instruction) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('• $instruction'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
