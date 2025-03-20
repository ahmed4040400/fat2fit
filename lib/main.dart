import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'intro_screen.dart';
import 'login_screen.dart';
import 'more_info_screen.dart';

void main() {
  // Add this to disable Impeller on Android/iOS
  // You can remove this once the issue is resolved
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
      ],
    );
  }
}
