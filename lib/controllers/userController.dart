import 'dart:io';
import 'dart:convert'; // ✅ Base64 Encoding
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
      getUserDetails();
    }
  }

  Future<void> saveUserDetails(
    String fullName,
    String email,
    File? image,
  ) async {
    try {
      User? user = auth.currentUser;
      if (user == null) return;

      String uid = user.uid;
      String? base64Image;

      if (image != null) {
        List<int> imageBytes = await image.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      Map<String, dynamic> existingData =
          doc.exists ? doc.data() as Map<String, dynamic> : {};

      UserModel userData = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        profilePictureUrl:
            base64Image ?? existingData['profilePictureUrl'] ?? "",
      );

      await firestore
          .collection('users')
          .doc(uid)
          .set(userData.toMap(), SetOptions(merge: true));

      userModel.value = userData;
      update();
      Get.snackbar("Success", "User details saved successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to save user details: ${e.toString()}");
    }
  }

  Future<void> getUserDetails() async {
    try {
      User? user = auth.currentUser;
      if (user == null) return;

      String uid = user.uid;
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user details");
    }
  }

  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      return profileImage.value;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      userModel.value = null;
      profileImage.value = null;
      update(); // Refresh UI
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Failed to log out");
    }
  }
}
