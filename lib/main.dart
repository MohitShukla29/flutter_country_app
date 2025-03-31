import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_app/screens/country_list_screen.dart';
import 'package:flutter_country_app/screens/profile_screen.dart';
import 'package:flutter_country_app/screens/splash_screen.dart';
import 'package:flutter_country_app/screens/user_info_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:flutter_country_app/screens/login_screen.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/theme_controller.dart';
import 'controllers/userController.dart';
import 'firebase_options.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init(); // Initialize local storage
  Get.put(ThemeController(), permanent: true); // Register ThemeController
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return GetMaterialApp( // ✅ Use GetMaterialApp instead of MaterialApp
      title: 'Flutter Country App',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/', page: () => OTPScreen()),
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/info', page: () => UserInfoScreen()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/country', page: () => CountryListScreen()),
      ],
    );
  }
}
