import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../home.dart';
import '../screens/user_info_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  var verificationId = ''.obs;
  var isLoading = false.obs;

  Future<void> SendOTP(String phoneNumber) async {
    isLoading(true);
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Get.snackbar("Success", "Phone Number Verified");
        isLoading(false);
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading(false);
        Get.snackbar("Error", e.message ?? "Something went wrong");
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId.value = verificationId;
        isLoading(false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }


  Future<void> verifyOTP(String otp) async {
    if (verificationId.value.isEmpty) {
      Get.snackbar("Error", "Verification ID is missing. Please request OTP again.");
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Get.toNamed('/info');
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP. Please try again.");
    }
  }

}
