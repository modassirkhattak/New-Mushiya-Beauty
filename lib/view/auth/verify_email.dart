import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/utills/custom_alert_dilaog.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:pinput/pinput.dart';

import '../../controller/forgot_provvider.dart';
import '../../controller/sign_up_provider.dart';

class VerifyEmailPage extends StatelessWidget {
  VerifyEmailPage({super.key});

  final controller = Get.put(ForgotPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: Column(
        children: [
          SizedBox(height: 105),
          const Center(
            child: Image(
              image: AssetImage('assets/extra_images/app_logo.png'),
              height: 74,
            ),
          ),
          // Spacer(),
          SizedBox(height: 48),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // spacing: 24,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Verify email".toUpperCase(),
                        fontSize: 22,
                        fontFamily: 'Archivo',
                        color: primaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: CustomText(
                        text:
                            "Enter the 6 digit code we have sent to ${Get.put(SignUpProvider()).emailController.text}",
                        fontSize: 16,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        fontFamily: 'Archivo',
                        color: primaryBlackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Pinput(
                        errorTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                        length: 6,
                        controller: controller.verifyPinController,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        defaultPinTheme: PinTheme(
                          width: 46,
                          height: 52,
                          textStyle: GoogleFonts.roboto(
                            color: primaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x19506784),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Obx(
                        () =>
                            controller.onClick.value == true &&
                                    controller.verifyPinController.text == ""
                                ? const Text(
                                  "Enter the code.",
                                  style: TextStyle(color: Colors.red),
                                )
                                : controller.onClick.value == true &&
                                    controller.verifyPinController.length != 6
                                ? const Text(
                                  "The code must be of 6 digits.",
                                  style: TextStyle(color: Colors.red),
                                )
                                : const SizedBox(),
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomButton(
                      text: "Verify".toUpperCase(),
                      onPressed: () async {
                        controller.onClick.value = !controller.onClick.value;
                        if (controller.verifyPinController.length != 6 ||
                            controller.verifyPinController.text == "") {
                          controller.onClick.value = true;
                          return;
                        }
                        print(
                          'code--------- ${controller.verifyPinController.text} == ${controller.verificationCode.toString()}',
                        );
                        if (controller.verifyPinController.length == 6 &&
                            controller.verifyPinController.text ==
                                controller.verificationCode.toString()) {
                          // await controller.createAccount(context);
                          print('----------------signup------------');
                          // controller.resetTextFields();
                          controller.onClick.value = false;
                          controller.verifyPinController.clear();
                        } else {
                          if (controller.verifyPinController.text ==
                              Get.find<SignUpProvider>().verificationCode
                                  .toString()) {
                            Get.find<SignUpProvider>().isEmailVerified.value =
                                true;
                            Get.back();
                            // Get.find<SignUpController>().signInWithEmailPassword();
                          } else {
                            customAlertDialog(
                              "Failed Verification".tr,
                              "The verification code from SMS/OTP is invalid."
                                  .tr,
                            );
                          }
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: true,
                          //   barrierColor: primaryBlackColor.withOpacity(0.8),

                          //   builder:
                          //       (context) => const ResetLinkDialog(
                          //         text:
                          //             "Congratulations! Your account has been successfully created.",
                          //         iconPath:
                          //             "assets/icons_svg/done_check_icon.svg",
                          //         condition: "signup_done",
                          //       ),
                          // );
                          print("object");
                        }
                      },
                      backgroundColor: primaryBlackColor,
                      minWidth: double.infinity,
                      showBorder: false,
                      height: 48,
                    ),
                    SizedBox(height: 32),

                    Center(
                      child: CustomText(
                        text: "Didn't receive the code?",
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: primaryBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Get.find<SignUpProvider>().sendEmail(
                          isFromResendOtp: true,
                        );
                      },
                      child: Center(
                        child: CustomText(
                          text: "Resend Code",
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
