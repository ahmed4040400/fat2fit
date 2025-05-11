import 'package:fat2fit/screens/exercise_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_api_controller.dart';

class Exercise {
  final String title;

  final String imageUrl;

  Exercise({required this.title, required this.imageUrl});
}

class ExerciseScreen extends StatelessWidget {
  ExerciseScreen({Key? key}) : super(key: key);

  final ExerciseApiController exerciseController = Get.put(
    ExerciseApiController(),
  );

  final List<Exercise> exercises = [
    Exercise(title: 'back', imageUrl: 'assets/images/back.png'),
    Exercise(title: 'chest', imageUrl: 'assets/images/chest.png'),
    Exercise(title: 'lower arms', imageUrl: 'assets/images/lower_arm.png'),
    Exercise(title: 'upper arms', imageUrl: 'assets/images/upper_arm.png'),
    Exercise(title: 'neck', imageUrl: 'assets/images/neck.png'),
    Exercise(title: 'waist', imageUrl: 'assets/images/waist.png'),
    Exercise(title: 'shoulders', imageUrl: 'assets/images/shoulders.png'),
    Exercise(title: 'upper legs', imageUrl: 'assets/images/upper_leg.png'),
    Exercise(title: 'lower legs', imageUrl: 'assets/images/lower_leg.png'),
    Exercise(title: 'cardio', imageUrl: 'assets/images/cardio.png'),
  ];

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          // Exercise icon in circle
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workouts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Your daily exercises',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          tooltip: 'Schedule',
          onPressed: () {
            // Handle schedule button press
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          tooltip: 'Filter Exercises',
          onPressed: () {
            // Handle filter button press
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                color: Colors.white,
                elevation: 4,
                child: InkWell(
                  splashColor: Colors.green.withOpacity(0.3),
                  highlightColor: Colors.green.withOpacity(0.1),
                  onTap: () async {
                    // final fetchedExercises = await exerciseController
                    //     .fetchExercises(exercises[index].title);
                    // print(
                    //   'Fetched ${fetchedExercises.length} exercises for ${exercises[index].title}',
                    // );
                    Get.put(ExerciseApiController());

                    Get.to(
                      () => ExerciseListScreen(
                        muscleType: exercises[index].title,
                      ),
                    );
                    // TODO: Navigate to exercises list screen or show the exercises
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          exercises[index].imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          exercises[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
