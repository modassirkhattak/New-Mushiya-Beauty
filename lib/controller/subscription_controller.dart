import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pCodeController = TextEditingController();
  final phoneNoController = TextEditingController();

  RxBool isCheckedSupport = false.obs;
  RxString isCheckedDelivery = ''.obs;

  final selectedPaymentMethod = ''.obs;
  final paymentMethods = [
    {
      'name': 'Monthly Plan',
      'icon': 'assets/icons_svg/PayPal.svg',
      'subText': "\$9.99/month",
    },
    {
      'name': 'Annual Plan',
      'icon': 'assets/icons_svg/PayPal.svg',
      'subText': "\$60.99/month",
    },
    {
      'name': 'Lifetime Plan',
      'icon': 'assets/icons_svg/Group.svg',
      'subText': "\$99.99/month",
    },
  ];
}
