import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mushiya_beauty/controller/whole_sale_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_dialog.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

class RequestAccessPage extends StatelessWidget {
  RequestAccessPage({super.key});

  final controller = Get.put(WholeSaleController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: 'Request'.toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Name",
                    textEditingController: controller.nameController,
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),

                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  // Obx(() => controller.nameError.value.isNotEmpty
                  //     ? Padding(
                  //   padding: const EdgeInsets.only(left: 12.0, top: 4),
                  //   child: Text(
                  //     controller.nameError.value,
                  //     style: TextStyle(color: Colors.red, fontSize: 12),
                  //   ),
                  // )
                  //     : SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Email",
                    textEditingController: controller.emailController,
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  // Obx(() => controller.emailError.value.isNotEmpty
                  //     ? Padding(
                  //   padding: const EdgeInsets.only(left: 12.0, top: 4),
                  //   child: Text(
                  //     controller.emailError.value,
                  //     style: TextStyle(color: Colors.red, fontSize: 12),
                  //   ),
                  // )
                  //     : SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Business name",
                    textEditingController: controller.bNameController,
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                  ),
                  // Obx(() => controller.bNameError.value.isNotEmpty
                  //     ? Padding(
                  //   padding: const EdgeInsets.only(left: 12.0, top: 4),
                  //   child: Text(
                  //     controller.bNameError.value,
                  //     style: TextStyle(color: Colors.red, fontSize: 12),
                  //   ),
                  // )
                  //     : SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Type of business",
                    textEditingController: controller.bTypeController,
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business type';
                      }
                      return null;
                    },
                  ),
                  // Obx(() => controller.bTypeError.value.isNotEmpty
                  //     ? Padding(
                  //   padding: const EdgeInsets.only(left: 12.0, top: 4),
                  //   child: Text(
                  //     controller.bTypeError.value,
                  //     style: TextStyle(color: Colors.red, fontSize: 12),
                  //   ),
                  // )
                  //     : SizedBox.shrink()),
                ],
              ),
              SizedBox(height: 32),
              CustomButton(
                text: "Request access".toUpperCase(),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.wholeSaleRequestSend();
                  } else {
                    // Update error messages in controller
                    controller.validateForm();
                  }
                },
                backgroundColor: whiteColor,
                textColor: primaryBlackColor,
                fontSize: 14,
                minWidth: double.infinity,
                fontWeight: FontWeight.w600,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}