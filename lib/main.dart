import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'intro_screen.dart';
import 'login_screen.dart';
import 'more_info_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/nutrition_controller.dart';
import 'screens/main_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Controllers
  Get.put(AuthController());
  Get.put(NutritionController()); // Add this line to initialize the NutritionController

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/intro',
      getPages: [
        GetPage(name: '/intro', page: () => const IntroScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const MoreInfoPage()),
        GetPage(name: '/main', page: () => const MainScreen()),
        GetPage(name: '/home_page', page: () => HomeScreen()), // Ensure HomeScreen route is defined
      ],
    );
  }
}
