import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:convert';

import 'package:mushiya_beauty/utills/api_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/utills/connectivity_check.dart';
import 'package:mushiya_beauty/utills/custom_alert_dilaog.dart';
import 'package:mushiya_beauty/view/auth/verify_email.dart';
import 'package:mushiya_beauty/view/bottom_bar/bottom_bar_page.dart';
import 'package:mushiya_beauty/widget/custom_dialog.dart';
import 'package:mushiya_beauty/widget/loading_dialog.dart';

class SignUpProvider extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  int? verificationCode;
  RxBool isAgree = false.obs;
  RxBool isEmailVerified = false.obs;

  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;

  final String adminToken = ADMIN_TOKEN;

  void _showMessage(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor:
          isError ? Get.theme.colorScheme.error : Get.theme.primaryColor,
      colorText:
          isError
              ? Get.theme.colorScheme.onError
              : Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> createShopifyCustomer({
    required bool isCustomerSignUp,
    User? user,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL$REGISTER_USER'),
        headers: headerApi,
        body: json.encode({
          'customer': {
            'first_name':
                isCustomerSignUp
                    ? firstNameController.text
                    : user!.displayName?.split(' ').first ?? 'User',
            'last_name':
                isCustomerSignUp
                    ? lastNameController.text
                    : user!.displayName?.split(' ').last ?? '',
            'email': isCustomerSignUp ? emailController.text : user!.email,
            'verified_email': true,
            "phone":
                isCustomerSignUp ? phoneController.text : user!.phoneNumber,
            'password': isCustomerSignUp ? passwordController.text : '',
            'password_confirmation': confirmPasswordController.text,
          },
        }),
      );

      if (response.statusCode != 201) {
        Get.back();
        throw Exception('Failed to create Shopify customer');
      }
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: primaryBlackColor.withOpacity(0.8),
        builder:
            (context) => const ResetLinkDialog(
              text:
                  "Congratulations! Your account has been successfully created.",
              iconPath: "assets/icons_svg/done_check_icon.svg",
              condition: "signup_done",
            ),
      );
      clearController();
    } catch (e) {
      Get.back();
      _showMessage("Shopify Error", e.toString(), isError: true);
    }
  }

  // ✅ New email check method
  Future<bool> checkEmailExit({String? email}) async {
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        email ?? emailController.text.trim(),
      );

      return methods.isEmpty; // true means new user (email doesn't exist)
    } catch (e) {
      print('Error checking email: $e');
      return false; // default to false to prevent registration in error cases
    }
  }

  sendVerificationEmail() async {
    loadingDialog(message: "Wait...".tr, loading: true);
    var networkStatus = await checkConnectivity();

    if (networkStatus == false) {
      Get.back();
      customAlertDialog(
        'Network error'.tr,
        'Please check your network connection & retry'.tr,
      );
    } else {
      var isEmailExit = await checkEmailExit();
      if (isEmailExit == false) {
        Get.back();
        customAlertDialog(
          'Email'.tr,
          'This email account is already in use.'.tr,
        );
      } else {
        Get.back();
        await sendEmail();
      }
    }
  }

  Future<void> sendEmail({bool isFromResendOtp = false}) async {
    loadingDialog(
      message: "Sending email verification code...".tr,
      loading: true,
    );
    String username = 'aliischeema@gmail.com';
    String password = 'ghst viwt drrf pzfq';
    verificationCode = Random().nextInt(99999) + 100000;
    final smtpServer = gmail(username, password);

    final message =
        Message()
          ..from = Address(username, "Mushiya Beauty")
          ..recipients.add(emailController.text)
          ..subject = 'Verification Code $verificationCode'
          ..html =
              "<p>$verificationCode is verification code for ${emailController.text}</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      Get.back();
      if (!isFromResendOtp) {
        Get.to(() => VerifyEmailPage());
      }
    } on MailerException catch (e) {
      Get.back();
      print('Message not sent. ${e.message}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    loadingDialog(message: "Signing in with Google...".tr, loading: true);
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception("Google sign-in cancelled");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var isEmailNotExit = await checkEmailExit(email: googleUser.email);
      if (isEmailNotExit == false) {
        Get.back();
        // customAlertDialog(
        //   'Email'.tr,
        //   'This email account is already in use.'.tr,
        // );
        Get.offAll(() => BottomBarPage());
        return null;
      }

      UserCredential result = await _auth.signInWithCredential(credential);
      _showMessage(
        "Google Login",
        "Welcome ${result.user?.displayName ?? 'User'}",
      );
      await createShopifyCustomer(user: result.user!, isCustomerSignUp: false);
      // clearController();
      return result.user;
    } catch (e) {
      Get.back();
      _showMessage("Google Sign-In Error", e.toString(), isError: true);
      return null;
    } finally {
      Get.back();
      isLoading.value = false;
    }
  }

  // Future<User?> signInWithFacebook() async {
  //   loadingDialog(message: "Signing in with Facebook...".tr, loading: true);
  //   isLoading.value = true;
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status != LoginStatus.success) {
  //       throw Exception(result.message ?? 'Facebook login failed');
  //     }

  //     final OAuthCredential credential = FacebookAuthProvider.credential(
  //       result.accessToken!.tokenString,
  //     );
  //     UserCredential userCredential = await _auth.signInWithCredential(
  //       credential,
  //     );

  //     var isEmailNotExit = await checkEmailExit(
  //       email: userCredential.user?.email,
  //     );
  //     if (isEmailNotExit == false) {
  //       Get.back();
  //       customAlertDialog(
  //         'Email'.tr,
  //         'This email account is already in use.'.tr,
  //       );
  //       Get.to(() => BottomBarPage());
  //       return null;
  //     }

  //     _showMessage(
  //       "Facebook Login",
  //       "Welcome ${userCredential.user?.displayName ?? 'User'}",
  //     );
  //     await createShopifyCustomer(
  //       user: userCredential.user!,
  //       isCustomerSignUp: false,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     Get.back();
  //     _showMessage("Facebook Sign-In Error", e.toString(), isError: true);
  //     return null;
  //   } finally {
  //     Get.back();
  //     isLoading.value = false;
  //   }
  // }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      // await FacebookAuth.instance.logOut();
      _showMessage("Logged Out", "You have been signed out successfully.");
    } catch (e) {
      _showMessage("Sign Out Error", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearController() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
  }
}
