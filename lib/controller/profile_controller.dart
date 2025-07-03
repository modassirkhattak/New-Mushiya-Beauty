import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mushiya_beauty/model/customer_model.dart';
import 'package:mushiya_beauty/model/update_customer_mdoel.dart';
import 'package:mushiya_beauty/utills/services.dart';

class ProfileController extends GetxController {
  var selectedImage = Rx<File?>(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var name = ''.obs;
  var selectedLanguage = 'English'.obs;

  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  final isObscure = true.obs;
  final isObscureNew = true.obs;
  final isObscureConfirm = true.obs;

  var isLoading = false.obs;
  var customer = Rxn<CustomerModel>();
  var error = ''.obs;

  var isUpdteCustomerLoading = false.obs;
  var messageUpdteCustomer = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Optionally call fetchCustomer() with a real ID
    // fetchCustomer(ApiServices.customerId);
  }

  Future<void> fetchCustomer() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await ApiServices.getCustomer();
      if (result != null) {
        customer.value = result;
        nameController.text = '${result.firstName} ${result.lastName}';
        emailController.text = result.email;
      } else {
        error.value = 'Failed to fetch customer.';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> updateCustomer({required String name, required int cID}) async {
    isUpdteCustomerLoading.value = true;

    UpdateCustomerMdoel customer = UpdateCustomerMdoel(
      id: cID,
      firstName: name,
      note: selectedImage.value?.path ?? "",
    );

    final result = await ApiServices().updateCustomer(customer);
    messageUpdteCustomer.value = result ?? "Unknown error";

    isUpdteCustomerLoading.value = false;
  }
}
