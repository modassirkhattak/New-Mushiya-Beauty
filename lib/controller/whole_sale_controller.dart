import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/model/whole_sale_prroduct_model.dart';
import 'package:mushiya_beauty/widget/loading_dialog.dart';

import '../utills/app_colors.dart';
import '../widget/custom_dialog.dart';

class WholeSaleController extends GetxController {
  RxBool isWholeSale = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bNameController = TextEditingController();
  final bTypeController = TextEditingController();

  // Error messages
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString bNameError = ''.obs;
  final RxString bTypeError = ''.obs;

  void validateForm() {
    // Name validation
    if (nameController.text.isEmpty) {
      nameError.value = 'Please enter your name';
    } else {
      nameError.value = '';
    }

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Please enter your email';
    } else if (!emailController.text.contains('@') ||
        !emailController.text.contains('.')) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }

    // Business name validation
    if (bNameController.text.isEmpty) {
      bNameError.value = 'Please enter your business name';
    } else {
      bNameError.value = '';
    }

    // Business type validation
    if (bTypeController.text.isEmpty) {
      bTypeError.value = 'Please enter your business type';
    } else {
      bTypeError.value = '';
    }
  }

  void wholeSaleRequestSend() {
    loadingDialog(message: "Sending request...".tr, loading: true);
    FirebaseFirestore.instance
        .collection("WholeSaleRequest")
        .add({
          "name": nameController.text,
          "email": emailController.text,
          "bName": bNameController.text,
          "bType": bTypeController.text,
          "status": "Pending",
          "time": DateTime.now(),
          "userID": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) {
          Get.back();
          showDialog(
            context: Get.context!,
            barrierDismissible: true,
            barrierColor: primaryBlackColor.withOpacity(0.8),

            builder:
                (context) => ResetLinkDialog(
                  text: "Your wholesale application is under review",
                  iconPath: "assets/icons_svg/done_check_icon.svg",
                  condition: "request_success",
                  image: false,
                  textName: "Wholesale application",
                ),
          );
          clearAllData();
        });
  }

  void clearAllData() {
    nameController.clear();
    emailController.clear();
    bNameController.clear();
    bTypeController.clear();
  }

  // wholeSale products
  RxList<WholeSalePrroductModel> productList = <WholeSalePrroductModel>[].obs;
  RxList<WholeSalePrroductModel> filteredList = <WholeSalePrroductModel>[].obs;
  RxString searchText = ''.obs;
  RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getProductStream().listen((products) {
      productList.value = products;
      filteredList.value = products;
    });

    searchText.listen((value) {
      filterProducts(value);
    });
  }

  Stream<List<WholeSalePrroductModel>> getProductStream() {
    return FirebaseFirestore.instance
        .collection('WholeSaleProducts')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return WholeSalePrroductModel.fromDocument(doc.data(), doc.id);
          }).toList();
        });
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredList.value = productList;
    } else {
      filteredList.value =
          productList
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
