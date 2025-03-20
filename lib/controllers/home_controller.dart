import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeController extends GetxController {
  final PersistentTabController tabController = PersistentTabController(
    initialIndex: 0,
  );

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorSecondary: Colors.green,
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: 'Chat',
        activeColorSecondary: Colors.green,
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.fitness_center),
        title: 'Exercise',
        activeColorSecondary: Colors.green,
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.restaurant_menu),
        title: 'Nutrition',
        activeColorSecondary: Colors.green,
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.info),
        title: 'Details',
        activeColorSecondary: Colors.green,
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
