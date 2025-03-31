import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/userController.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {

      if (!Get.isRegistered<UserController>()) {
        Get.put(UserController(), permanent: true);
      }


      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Get.offAllNamed('/country');
      } else {
        Get.offAllNamed('/');
      }
    });

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
