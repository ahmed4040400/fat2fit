import 'dart:math';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exercise_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class ExerciseApiController extends GetxController {
  static const baseUrl = 'https://exercisedb.p.rapidapi.com';

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Exercise> exercises = <Exercise>[].obs;
  final Rx<Exercise?> currentExercise = Rx<Exercise?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Exercise>> fetchExercises(String muscleType) async {
    try {
      isLoading.value = true;
      String offset = '${(Random().nextInt(10) + 1) * 10}';

      // Show loading animation
      Get.dialog(
        Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 50,
          ),
        ),
        barrierDismissible: false,
      );

      if (muscleType == 'cardio') {
        offset = '10';
      }
      final response = await http.get(
        Uri.parse(
          '$baseUrl/exercises/bodyPart/$muscleType?limit=10&offset=$offset',
        ),
        headers: {
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-rapidapi-key':
              '99d832fb6amsh75cc35dc844c779p1e56f7jsn6b61e9e31b17',
        },
      );

      // Close loading dialog
      Get.back();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Exercise> fetchedExercises =
            data.map((json) => Exercise.fromJson(json)).toList();
        exercises.value = fetchedExercises; // Update the exercises list
        return fetchedExercises;
      } else {
        error.value = 'Failed to load exercises: ${response.statusCode}';
        return [];
      }
    } catch (e) {
      // Close loading dialog in case of error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      error.value = 'Error: $e';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getExerciseById(String id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.get(Uri.parse('$baseUrl/exercises/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currentExercise.value = Exercise.fromJson(data);
      } else {
        error.value = 'Failed to load exercise: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshExercises(String muscleType) async {
    try {
      String offset = '${(Random().nextInt(10) + 1) * 10}';

      isLoading.value = true;
      error.value = '';

      if (muscleType == 'cardio') {
        offset = '${(Random().nextInt(2) + 1) * 2}';
      }
      final response = await http.get(
        Uri.parse(
          '$baseUrl/exercises/bodyPart/$muscleType?limit=10&offset=$offset',
        ),
        headers: {
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-rapidapi-key':
              '99d832fb6amsh75cc35dc844c779p1e56f7jsn6b61e9e31b17',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        exercises.value = data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        error.value = 'Failed to load exercises: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
