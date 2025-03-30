import 'dart:io';
import 'dart:convert'; // ✅ Import for Base64 encoding
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/userModel.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  var profileImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    if (auth.currentUser != null) {
      getUserDetails(); // 🔥 Fetch user details when controller initializes
    }
  }

  Future<void> saveUserDetails(String fullName, String email, File? image) async {
    try {
      String uid = auth.currentUser!.uid;
      String? base64Image;

      // Convert image to Base64 if selected
      if (image != null) {
        List<int> imageBytes = await image.readAsBytes(); // Read file as bytes
        base64Image = base64Encode(imageBytes); // Encode to Base64
      }

      // Create user model
      UserModel user = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        profilePictureUrl: base64Image ?? userModel.value?.profilePictureUrl ?? "", // Keep old image if no new one
      );

      // Save user data to Firestore
      await firestore.collection('users').doc(uid).set(user.toMap());

      userModel.value = user;
      update(); // 🔥 Update UI with new data
      Get.snackbar("Success", "User details saved successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getUserDetails() async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        update(); // 🔥 Ensure UI updates when user details are fetched
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user details");
    }
  }

  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path); // ✅ Updates reactive variable
      return profileImage.value;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await auth.signOut(); // Firebase sign out
      userModel.value = null; // Clear user data
      profileImage.value = null; // Clear profile image
      update(); // Update UI
      Get.offAllNamed('/'); // Redirect to login screen
    } catch (e) {
      Get.snackbar("Error", "Failed to log out");
    }
  }
}
