import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/userController.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final ThemeController themeController = Get.find();

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .appBarTheme
            .backgroundColor,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings_outlined),
        //     onPressed: () {
        //       // Keeping the action empty to maintain original logic
        //     },
        //   ),
        // ],
        actions: [
          Obx(() =>
              IconButton(
                icon: Icon(
                    themeController.isDarkMode.value ? Icons.dark_mode : Icons
                        .light_mode),
                onPressed: () {
                  themeController.toggleTheme();
                },
              )),
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved background with profile image
            Container(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Curved background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .surface,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  // Profile image
                  Positioned(
                    top: 60,
                    child: Obx(() {
                      return Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Theme
                              .of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                          backgroundImage: userController.userModel.value
                              ?.profilePictureUrl != null &&
                              userController.userModel.value!.profilePictureUrl!
                                  .isNotEmpty
                              ? MemoryImage(base64Decode(
                              userController.userModel.value!
                                  .profilePictureUrl!))
                              : null,
                          child: userController.userModel.value
                              ?.profilePictureUrl == null ||
                              userController.userModel.value!.profilePictureUrl!
                                  .isEmpty
                              ? Icon(
                              Icons.account_circle, size: 65, color: Theme
                              .of(context)
                              .hintColor)
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // User information
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Full Name
                  Obx(() =>
                      Text(
                        userController.userModel.value?.fullName ?? "No Name",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge
                              ?.color,
                        ),
                      )),
                  SizedBox(height: 5),

                  // Email with icon
                  Obx(() =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            userController.userModel.value?.email ?? "No Email",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme
                                  .of(context)
                                  .hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),

                  SizedBox(height: 30),

                  // Profile Details Card
                  Container(
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile option - Edit Profile
                          _buildProfileOption(
                            icon: Icons.edit_outlined,
                            title: "Edit Profile",
                            color: Colors.blue,
                            onTap: () {
                              // Keeping empty to maintain original logic
                            },
                          ),

                          Divider(height: 25, thickness: 1, color: Theme
                              .of(context)
                              .dividerColor),

                          // Profile option - Privacy Settings
                          _buildProfileOption(
                            icon: Icons.lock_outline,
                            title: "Privacy Settings",
                            color: Colors.orange,
                            onTap: () {
                              // Keeping empty to maintain original logic
                            },
                          ),

                          Divider(height: 25, thickness: 1),

                          // Profile option - Help & Support
                          _buildProfileOption(
                            icon: Icons.help_outline,
                            title: "Help & Support",
                            color: Colors.green,
                            onTap: () {
                              // Keeping empty to maintain original logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await userController.logout(); // Perform logout
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // App version
                  Text(
                    "App Version 1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme
                          .of(context)
                          .hintColor,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build profile option items
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(builder: (context) {
      bool isDarkMode = Theme
          .of(context)
          .brightness == Brightness.dark;
      Color textColor = isDarkMode ? Colors.white : Colors.black87;

      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color, // Keep icon color as per input
                  size: 22,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor, // ✅ Ensure text is white in dark mode
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white54 : Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }
}