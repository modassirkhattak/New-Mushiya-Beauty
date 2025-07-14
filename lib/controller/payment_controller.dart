import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utills/app_colors.dart';
import '../widget/custom_dialog.dart';
import 'cart_controller.dart' show CartController, CartSaloonController;

class PaymentController extends GetxController {
  initializeStripe({required String publishKey}) async {
    Stripe.publishableKey = publishKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    await Stripe.instance.applySettings();
  }

  Map<String, dynamic>? paymentIntentData;

  void payIn() {
    paymentIntentData = null;
  }

  Future<String> makePayment(
      {required String price}) async {
    var isPaymentDone;
    try {
Get.dialog(Center(child: CircularProgressIndicator(),));
Map<String, dynamic> paymentIntent = await createPaymentIntent(
          amount: price);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // customFlow: false,
          appearance: PaymentSheetAppearance(),
          style: ThemeMode.dark,

          merchantDisplayName: 'Mushiya Beauty Eat',
          customerId: paymentIntent['customer'],
          paymentIntentClientSecret: paymentIntent['client_secret'],
          customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
          // applePay: const PaymentSheetApplePay(
          //     buttonType: PlatformButtonType.book,
          //     merchantCountryCode: 'US',
          //     request: PaymentRequestType.automaticReload(
          //         description: '',
          //         managementUrl: '',
          //         label: '',
          //         reloadAmount: '90',
          //         thresholdAmount: '123')),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   testEnv: true,
          // ),
        ),
      );

      await Stripe.instance.presentPaymentSheet().then((value) {
        isPaymentDone = paymentIntent['id'];

        // if(isPaymentDone){
          FirebaseFirestore.instance.collection("ServiceBook").add({
            'items': Get.find<CartSaloonController>().cartItems.map((e) => e.toJson()).toList(),
            "userId": FirebaseAuth.instance.currentUser!.uid,
            "email": FirebaseAuth.instance.currentUser!.email
          }).then((va){
            showDialog(
              context: Get.context!,
              barrierDismissible: true,
              barrierColor: primaryBlackColor.withOpacity(0.8),

              builder:
                  (context) => const ResetLinkDialog(
                text:
                "Your order has been placed successfully",
                iconPath:
                "assets/icons_svg/done_check_icon.svg",
                condition: "order_success",
              ),
            );
          });
        // }


      }).onError((error, stackTrace) {
        Get.back();
        print("1 Here i am $error");
      });
    } catch (e) {
      Get.back();
      isPaymentDone = "";
      print(e);
      // customAlertDialog("Failed", "Something went wrong");
    }
    return isPaymentDone;
  }

  Future createPaymentIntent(
      {required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_BQokikJOvBiI2HlWgH4olfQ2',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      if (kDebugMode) {
        print(response.body.toString());
      }
      print("response.statusCode)");
      print(response.statusCode);
      if(response.statusCode==200){


      }
      return jsonDecode(response.body.toString());

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  calculateAmount(String amount) {
    final price = (double.parse(amount) * 100).floor();
    return price.toString();
  }
}