import 'dart:developer';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Future<void> verifyOTP(String otpCode, String verificationId) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential);

      // Navigate to the VerificationPage after successful verification
    } catch (e) {
      // Handle verification failure
      log('Error during OTP verification: $e');
    } finally {
      isLoading.value = false;
    }
  }
}