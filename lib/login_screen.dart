import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'more_info_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'Fat2Fit',

        hideForgotPasswordButton: true,
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Get.offNamed('/home');
        },
        onRecoverPassword: (String name) {
          return Future.value(null);
        },
        theme: LoginTheme(
          primaryColor: Colors.green, // Set background color to green
          titleStyle: const TextStyle(
            color: Colors.white,
          ), // Set title color to white
        ),
      ),
    );
  }
}
