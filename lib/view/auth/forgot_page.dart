import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mushiya_beauty/utills/app_colors.dart';

import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart'
    show CustomTextField;
import 'package:pinput/pinput.dart';

import '../../controller/forgot_provvider.dart';

import '../../widget/custom_dialog.dart' show ResetLinkDialog;

class ForgotPage extends StatelessWidget {
  ForgotPage({super.key});

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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomText(
                          text:
                              "No worries. Baby naps enhance memory. Enter your email.",
                          fontSize: 16,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          fontFamily: 'Archivo',
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      height: 48,
                      hintText: 'Email',
                      textEditingController: controller.emailController,
                      fillColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      isBorder: true,
                      // onValidate: (val) {
                      //   if (val == null || val.isEmpty) return 'Email required';
                      //   if (!GetUtils.isEmail(val)) return 'Enter valid email';
                      //   return null;
                      // },
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
                      text: "Submit".toUpperCase(),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => const ResetLinkDialog(),
                        );

                        // controller.onClick.value = !controller.onClick.value;
                        // if (controller.verifyPinController.length != 6 ||
                        //     controller.verifyPinController.text == "") {
                        //   controller.onClick.value = true;
                        //   return;
                        // }
                        // print(
                        //   'code--------- ${controller.verifyPinController.text} == ${controller.verificationCode.toString()}',
                        // );
                        // if (controller.verifyPinController.length == 6 &&
                        //     controller.verifyPinController.text ==
                        //         controller.verificationCode.toString()) {
                        //   // await controller.createAccount(context);
                        //   print('----------------signup------------');
                        //   // controller.resetTextFields();
                        //   controller.onClick.value = false;
                        //   controller.verifyPinController.clear();
                        // } else {}
                      },
                      backgroundColor: primaryBlackColor,
                      minWidth: double.infinity,
                      showBorder: false,
                      height: 48,
                    ),
                    SizedBox(height: 32),

                    Center(
                      child: CustomText(
                        text: "Resend!".toUpperCase(),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: primaryBlackColor,
                        fontWeight: FontWeight.w600,
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
