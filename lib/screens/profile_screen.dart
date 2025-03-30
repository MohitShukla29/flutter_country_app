import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Profile Image with Shadow
            Obx(() {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: userController.userModel.value?.profilePictureUrl != null &&
                      userController.userModel.value!.profilePictureUrl!.isNotEmpty
                      ? MemoryImage(base64Decode(userController.userModel.value!.profilePictureUrl!))
                      : null,
                  child: userController.userModel.value?.profilePictureUrl == null ||
                      userController.userModel.value!.profilePictureUrl!.isEmpty
                      ? Icon(Icons.account_circle, size: 60, color: Colors.grey)
                      : null,
                ),
              );
            }),
            SizedBox(height: 16),

            // ✅ Profile Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ✅ Full Name
                    Obx(() => Text(
                      userController.userModel.value?.fullName ?? "No Name",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    )),
                    SizedBox(height: 8),

                    // ✅ Email
                    Obx(() => Text(
                      userController.userModel.value?.email ?? "No Email",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // ✅ Logout Button with Rounded Shape
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await userController.logout();  // Perform logout// Navigate to Login Page (Replace with your actual route)
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
