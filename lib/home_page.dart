import 'package:fat2fit/screens/exercise_screen.dart';
import 'package:fat2fit/screens/nutrition_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'controllers/home_controller.dart';
import 'screens/main_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/details_screen.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: [
        MainScreen(),
        ChatScreen(),
        ExerciseScreen(),
        NutritionScreen(),
        DetailsScreen(),
      ],
      items: controller.navBarItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style10,
    );
  }
}
