import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mission_test_svr_infotech/colors/colors.dart';
import 'package:mission_test_svr_infotech/constants/constants.dart';
import 'package:mission_test_svr_infotech/controllers/google_auth.dart';

import 'package:mission_test_svr_infotech/controllers/login_controllers.dart';
import 'package:mission_test_svr_infotech/views/otp_verification.dart';
import 'package:mission_test_svr_infotech/views/widgets/country_code.dart';
import 'package:mission_test_svr_infotech/views/widgets/button.dart';
import 'package:mission_test_svr_infotech/views/widgets/text_view.dart';
import 'package:mission_test_svr_infotech/views/widgets/textformfiled.dart';

String selectedCountryCode = '';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final MyFormController phoneContoller = Get.put(MyFormController());

  Future<void> verifyPhone() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      log("TEST_LOG============verificationCompleted=========>");
    }

    verificationFailed(FirebaseAuthException e) {
      log("TEST_LOG========failure=============>${e.message}");
    }

    codeSent(String verificationId, int? resendToken) {
      log("TEST_LOG===========Code shared==========>${verificationId}");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
                  verificationId: verificationId,
                  phoneNumber: phoneContoller.phonenumber.toString(),
                )),
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      log("TEST_LOG===========Time out==========>${verificationId}");
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '$selectedCountryCode $phoneContoller',
      timeout: const Duration(seconds: 30),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  bool isVerifying = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
                height: 330,
                decoration: const BoxDecoration(
                    color: AppColors.backgroundColr,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(15))),
                child: Stack(
                  children: [
                    Positioned(
                      top: 80,
                      left: 144,
                      child: Image.asset(
                        'assets/Graphicloads-100-Flat-Email-2-PhotoRoom.png',
                        height: 80,
                      ),
                    ),
                    Positioned(
                        top: 88,
                        left: 176,
                        child: Image.asset(
                          'assets/PikPng.com_telegram-png_708973.png',
                          height: 26,
                        ))
                  ],
                )),
          ),
          Positioned(
            top: 170,
            child: SizedBox(
              height: 600,
              child: Stack(
                children: [
                  (Container(
                    height: 380,
                    width: MediaQuery.of(context).size.width - 100,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              spreadRadius: 10,
                              blurRadius: 12)
                        ]),
                    child: Column(
                      children: [
                        kkbox,
                        const TextView(
                          text: 'Login',
                          colrs: AppColors.textColor,
                          size: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        kabox,
                        const TextView(
                          text: 'Enter your mobile to get',
                          fontWeight: FontWeight.w500,
                        ),
                        const TextView(
                          text: 'Login OTP',
                          fontWeight: FontWeight.w500,
                        ),
                        kzbox,
                        CountryDropdown(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 23),
                          child: TextformField(
                              onChanged: (value) =>
                                  phoneContoller.phonenumber.value = value,
                              text: 'Enter Your mobile number',
                              validator: (value) => phoneContoller
                                  .validatePhoneNumber(value ?? ''),
                              keyboardType: TextInputType.number,
                              inputFormatter: [
                                LengthLimitingTextInputFormatter(10),
                              ]),
                        ),
                      ],
                    ),
                  )),
                  Positioned(
                    top: 330,
                    left: 145,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1,
                                color: Colors.blueGrey.shade50,
                              )
                            ]),
                        height: 90,
                        width: 90,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 4,
                                left: 4,
                                child: InkWell(
                                  onTap: () {
                                    //  verifyPhone();
                                    if (phoneContoller
                                            .phonenumber.value.length <
                                        10) {
                                      Get.snackbar(
                                          'Please enter a valid phone number',
                                          colorText: Colors.white,
                                          '',
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP);
                                    } else {
                                      setState(() {
                                        isVerifying = true;
                                      });
                                      verifyPhone();
                                      phoneContoller.submit();
                                      log("added");
                                      Future.delayed(
                                        const Duration(seconds: 6),
                                        () {
                                          setState(() {
                                            isVerifying = false;
                                          });
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 82,
                                    width: 82,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        color: AppColors.backgroundColr),
                                    child: isVerifying
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                  ),
                                ))
                          ],
                        )),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.grey.shade300,
                              height: 36,
                            ),
                          ),
                        ),
                        const Text(
                          "OR",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.grey.shade300,
                              height: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 37,
                    left: 40,
                    child: MyButton(
                        ontaps: () async {
                          UserCredential? userCredential =
                              await GoogleAuth().signInWithGoogle();

                          if (userCredential != null) {
                            log('Signed in with Google: ${userCredential.user!.displayName}');
                          }
                        },
                        height: 50,
                        width: screenWidth - 80,
                        text: 'Login with Google',
                        color: Colors.white,
                        image:
                            'assets/kisspng-google-logo-5b02bbe210fa26.4684376415269058260696.png'),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
