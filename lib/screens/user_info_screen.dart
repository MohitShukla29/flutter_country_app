import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import 'country_list_screen.dart';

class UserInfoScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                File? pickedImage = await userController.pickImage();
                if (pickedImage != null) {
                  userController.profileImage.value = pickedImage;
                }
              },
              child: Obx(() => CircleAvatar(
                radius: 50,
                backgroundImage: userController.profileImage.value != null
                    ? FileImage(userController.profileImage.value!)
                    : null,
                child: userController.profileImage.value == null
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              )),
            ),
            SizedBox(height: 20),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userController.saveUserDetails(
                  fullNameController.text,
                  emailController.text,
                  userController.profileImage.value,
                );
                Get.toNamed('/country');
              },
              child: Text("Save and Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
