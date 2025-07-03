import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/sign_up_provider.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/auth/sign_up_page.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

import 'login_page.dart';

class StatedPage extends StatelessWidget {
  StatedPage({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 24,
                children: [
                  Center(
                    child: CustomText(
                      text: "GET STARTED",
                      fontSize: 22,
                      fontFamily: 'Archivo',
                      color: primaryBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomButton(
                    height: 48,
                    text: "Continue with Google",
                    isPrefixIcon: true,
                    onPressed: () {
                      controller.signInWithGoogle();
                    },
                    prefixIcon: Row(
                      children: [
                        SvgPicture.asset('assets/icons_svg/google_icon.svg'),
                        Spacer(),
                        CustomText(text: "Continue with Google"),
                        Spacer(),
                      ],
                    ),
                    showBorder: true,
                    minWidth: double.infinity,
                  ),
                  CustomButton(
                    height: 48,
                    text: "Continue with Email",
                    isPrefixIcon: true,
                    onPressed: () {
                      Get.to(LoginPage());
                    },
                    prefixIcon: Row(
                      children: [
                        SvgPicture.asset('assets/icons_svg/email.svg'),
                        Spacer(),
                        CustomText(text: "Continue with Email"),
                        Spacer(),
                      ],
                    ),
                    showBorder: true,
                    minWidth: double.infinity,
                  ),
                  CustomButton(
                    text: "SIGNUP",
                    onPressed: () {
                      Get.to(SignUpPage());
                    },
                    backgroundColor: primaryBlackColor,
                    minWidth: double.infinity,
                    showBorder: false,
                    height: 48,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Already have an account?",
                        fontFamily: 'Archivo',
                        fontWeight: FontWeight.w500,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(LoginPage());
                        },
                        child: CustomText(
                          text: " LOGIN",
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
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
