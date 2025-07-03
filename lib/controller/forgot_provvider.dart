import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPageController extends GetxController {
  final verifyPinController = TextEditingController();
  final emailController = TextEditingController();


  var onClick = false.obs;

  void resetField() {
    verifyPinController.clear();
  }

  int? verificationCode;

}