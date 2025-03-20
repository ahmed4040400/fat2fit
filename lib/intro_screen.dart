import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'more_info_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white, // Set background color to white
      pages: [
        PageViewModel(
          title: "Workout Plan",
          body: "Get personalized workout plans tailored to your goals.",
          image: Center(
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/9048/9048294.png',
              height: 200, // Set the height of the image
            ),
          ),
        ),
        PageViewModel(
          title: "Diet Plan",
          body: "Receive diet plans to complement your workout routine.",
          image: Center(
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/7924/7924064.png',
              height: 200, // Set the height of the image
            ),
          ),
        ),
        PageViewModel(
          title: "Chatbot Assistance",
          body: "Use our chatbot to get help with your diet and workouts.",
          image: Center(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/007/225/199/non_2x/robot-chat-bot-concept-illustration-vector.jpg',
              height: 200, // Increase the height to make the image bigger
            ),
          ),
        ),
      ],
      onDone: () {
        Get.offNamed('/login');
      },
      onSkip: () {
        Get.offNamed('/login');
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
