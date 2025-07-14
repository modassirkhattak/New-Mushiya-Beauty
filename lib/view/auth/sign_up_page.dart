import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/utills/connectivity_check.dart';
import 'package:mushiya_beauty/utills/custom_alert_dilaog.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

import '../../controller/sign_up_provider.dart';
import '../../widget/custom_checkbox.dart' show CustomCheckboxWithText;

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final controller = Get.put(SignUpProvider());
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
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 24,
                    children: [
                      Center(
                        child: CustomText(
                          text: "Signup".tr.toUpperCase(),
                          fontSize: 22,
                          fontFamily: 'Archivo',
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.name,
                        height: 48,
                        hintText: 'First Name'.tr,
                        textEditingController: controller.firstNameController,
                        fillColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        isBorder: true,
                        onValidate:
                            (val) =>
                                val!.isEmpty ? "First Name required".tr : null,
                      ),

                      CustomTextField(
                        keyboardType: TextInputType.name,
                        height: 48,
                        hintText: 'Last Name'.tr,
                        textEditingController: controller.lastNameController,
                        fillColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        isBorder: true,
                        onValidate:
                            (val) => val!.isEmpty ? "Last Name required".tr : null,
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        height: 48,
                        hintText: 'Email'.tr,
                        textEditingController: controller.emailController,
                        fillColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        isBorder: true,
                        onValidate: (val) {
                          if (val == null || val.isEmpty)
                            return 'Email required'.tr;
                          if (!GetUtils.isEmail(val))
                            return 'Enter valid email'.tr;
                          return null;
                        },
                        suffixIcon: Obx(
                          () => GestureDetector(
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                controller.sendVerificationEmail();
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    controller.isEmailVerified.value
                                        ? "Verified".tr
                                        : 'Verify'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryBlackColor,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => CustomTextField(
                          keyboardType: TextInputType.visiblePassword,
                          height: 48,
                          hintText: 'Password'.tr,
                          textEditingController: controller.passwordController,
                          fillColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          isBorder: true,
                          obscureText: controller.isPasswordVisible.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryBlackColor,
                            ),
                            onPressed: () {
                              controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                            },
                          ),
                          onValidate: (val) {
                            if (val == null || val.isEmpty)
                              return 'Password required'.tr;
                            if (val.length < 6) return 'Minimum 6 characters'.tr;
                            return null;
                          },
                        ),
                      ),
                      Obx(
                        () => CustomTextField(
                          keyboardType: TextInputType.visiblePassword,
                          height: 48,
                          hintText: 'Confirm Password'.tr,
                          textEditingController:
                              controller.confirmPasswordController,
                          fillColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          isBorder: true,
                          obscureText:
                              controller.isConfirmPasswordVisible.value,
                          // onChanged: (p0) =>  = '',
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryBlackColor,
                            ),
                            onPressed: () {
                              controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value;
                            },
                          ),
                          onValidate: (val) {
                            if (val == null || val.isEmpty)
                              return 'Confirm password required'.tr;
                            if (val != controller.passwordController.text)
                              return 'Passwords do not match'.tr;
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: CustomCheckboxWithText(
                          color: primaryBlackColor,
                          textColor: primaryBlackColor,
                          // text: "I agree to the Terms & Conditions",
                          isChecked: controller.isAgree,
                          onTap: () {
                            controller.isAgree.value =
                                !controller.isAgree.value;
                          },
                        ),
                      ),
                      CustomButton(
                        text: "SIGNUP".tr,
                        onPressed: () async {
                          if (!controller.isAgree.value) {
                            Get.snackbar(
                              "Error".tr,
                              "You must agree to the Terms & Conditions".tr,
                              backgroundColor: Colors.red.shade100,
                            );
                            return;
                          }
                          var networkStatus = await checkConnectivity();
                          if (networkStatus == false) {
                            customAlertDialog(
                              'Network error'.tr,
                              'Please check your network connection & retry'.tr,
                            );
                          } else if (controller.formKey.currentState!
                              .validate()) {
                            if (controller.isEmailVerified.isFalse) {
                              customAlertDialog(
                                'Email Verification'.tr,
                                'Please verify your email.'.tr,
                              );
                            } else if (controller.isAgree.value == false) {
                              customAlertDialog(
                                'Terms & Conditions'.tr,
                                'Please agree with our terms and conditions.'
                                    .tr,
                              );
                            } else {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.createUserWithEmailAndPassword(
                                email: controller.emailController.text,
                                password: controller.passwordController.text,
                              );

                              await controller.createShopifyCustomer(
                                isCustomerSignUp: true,
                              );
                            }
                          }
                        },
                        backgroundColor: primaryBlackColor,
                        minWidth: double.infinity,
                        showBorder: false,
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
