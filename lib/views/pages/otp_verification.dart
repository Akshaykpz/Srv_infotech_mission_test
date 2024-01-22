import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mission_test_svr_infotech/colors/colors.dart';
import 'package:mission_test_svr_infotech/constants/constants.dart';
import 'package:mission_test_svr_infotech/controllers/otp_controller.dart';
import 'package:mission_test_svr_infotech/controllers/resend_otp.dart';
import 'package:mission_test_svr_infotech/controllers/verification_controller.dart';

import 'package:mission_test_svr_infotech/views/widgets/button.dart';
import 'package:mission_test_svr_infotech/views/widgets/pinput_filed.dart';
import 'package:mission_test_svr_infotech/views/widgets/text_view.dart';

TextEditingController otpcontoller = TextEditingController();

class OtpverificationView extends StatefulWidget {
  final String? phoneNumber;
  final String? verificationId;
  final String? countrycode;
  const OtpverificationView(
      {super.key, this.phoneNumber, this.verificationId, this.countrycode});

  @override
  State<OtpverificationView> createState() => _OtpverificationViewState();
}

class _OtpverificationViewState extends State<OtpverificationView> {
//   bool isverifed = false;
  @override
  Widget build(BuildContext context) {
    String formattedPhoneNumber =
        VerificationController().hidePhoneNumber(widget.phoneNumber!);
    return Scaffold(
      backgroundColor: AppColors.backgroundColr,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            // color: Colors.black,
            child: Stack(
              children: [
                Stack(children: [
                  Positioned(
                    top: ScreenUtil().setHeight(150),
                    left: MediaQuery.of(context).size.width * 0.362,
                    child: Image.asset(
                      'assets/Graphicloads-100-Flat-Email-2-PhotoRoom.png',
                      height: ScreenUtil().setHeight(80),
                    ),
                  ),
                  Positioned(
                      top: ScreenUtil().setHeight(141),
                      left: MediaQuery.of(context).size.width * 0.450,
                      child: Icon(
                        Icons.check,
                        size: ScreenUtil().setHeight(48),
                        color: Colors.white,
                      )),
                ]),
                Positioned(
                  top: ScreenUtil().setHeight(230),
                  child: Container(
                    color: AppColors.backgroundColr,
                    height: MediaQuery.of(context).size.height * 1.10,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const TextView(
                          text: ' Enter OTP',
                          colrs: AppColors.newColor,
                          size: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        klbox,
                        Text(
                          'We have sent an OTP on',
                          style: newFont,
                        ),
                        Text("${widget.countrycode} $formattedPhoneNumber  ",
                            style: newFont),
                        kabox,
                        const PinputField(),
                        kabox,
                        MyButton(
                          textColor: Colors.white,
                          width: ScreenUtil().setWidth(280),
                          height: ScreenUtil().setHeight(40),
                          color: AppColors.textColor,
                          ontaps: () async {
                            OtpController().verifyOTP(
                                otpcontoller.text, widget.verificationId!);
                          },
                          text: 'Login',
                          fontWeight: FontWeight.w500,
                          fontsize: 23,
                        ),
                        kzbox,
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TextView(
                              text: "Don't receive OTP? ",
                              colrs: AppColors.newColor,
                            ),
                            // kkbox,
                            TextButton(
                              onPressed: () async {
                                ResendVerification().resendOtp(
                                    widget.countrycode.toString(),
                                    widget.phoneNumber.toString());
                              },
                              child: const Text(
                                "Resend",
                                style: TextStyle(color: AppColors.newColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
