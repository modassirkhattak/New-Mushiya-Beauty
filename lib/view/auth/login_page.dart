import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/login_provider.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/auth/sign_up_page.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

import 'forgot_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // final controller = Get.put(SignUpProvider());
  final authService = Get.put(ShopifyAuthService());
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
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: authService.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // spacing: 24,
                        children: [
                          Center(
                            child: CustomText(
                              text: "Welcome back".toUpperCase().tr,
                              fontSize: 22,
                              fontFamily: 'Archivo',
                              color: primaryBlackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 24),

                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            height: 48,
                            hintText: 'Email'.tr,
                            textEditingController: authService.emailController,
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
                          ),
                          SizedBox(height: 24),
                          Obx(
                            () => CustomTextField(
                              keyboardType: TextInputType.visiblePassword,
                              height: 48,
                              hintText: 'Password'.tr,
                              textEditingController:
                                  authService.passwordController,
                              fillColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              isBorder: true,
                              obscureText: authService.isPasswordVisible.value,
                              onChanged:
                                  (p0) => authService.errorMessage.value = '',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authService.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryBlackColor,
                                ),
                                onPressed: () {
                                  authService.isPasswordVisible.value =
                                      !authService.isPasswordVisible.value;
                                },
                              ),
                              onValidate: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Password required'.tr;
                                if (val.length < 6)
                                  return 'Minimum 6 characters'.tr;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ForgotPage());
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomText(
                                text: "Forgot Password?".tr,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: primaryBlackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ), //,(child: Align(alignment: Alignment.centerRight,child: CustomText(text: "Forgot Password?",fontSize: 16,fontFamily: 'Archivo',color: primaryBlackColor,fontWeight: FontWeight.w600,))),

                          SizedBox(height: 24),
                          CustomButton(
                            text: "LOGIN".tr,
                            onPressed: () async {
                              if (authService.formKey.currentState!
                                  .validate()) {
                                try {
                                  await authService.login(
                                    authService.emailController.text,
                                    authService.passwordController.text,
                                  );
                                  Get.back(); // Return to previous screen
                                } catch (e) {
                                  // Error is already handled in service
                                }
                                // ✅ Signup logic here
                                print("Signup successful!");
                                // Get.to(() => SignUpPage());
                              }
                            },
                            backgroundColor: primaryBlackColor,
                            minWidth: double.infinity,
                            showBorder: false,
                            height: 48,
                          ),
                          Obx(() {
                            print("Error : ${authService.errorMessage.value}");
                            if (authService.errorMessage.value.isNotEmpty) {
                              return Text(
                                authService.errorMessage.value,
                                style: const TextStyle(color: Colors.red),
                              );
                            }
                            return const SizedBox();
                          }),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don’t have account? ".tr,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(SignUpPage());
                        },
                        child: CustomText(
                          text: "Signup".tr.toUpperCase(),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
