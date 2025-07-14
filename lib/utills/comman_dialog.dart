import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/profile_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

import '../view/language/controller/language_controller.dart';
import '../view/language/controller/localization_controller.dart';
import '../view/language/utils/constant.dart';

showLanguageDialog() {
  Get.find<LanguageController>().initializeAllLanguages(Get.context!);
  final ProfileController controller = Get.find<ProfileController>();

  // final LanguageController languageController = Get.find<LanguageController>();

  return AlertDialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Center(
      child: CustomText(
        text: 'Language'.tr,
        color: primaryBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: "Roboto",
      ),
    ),
    content: GetBuilder<LanguageController>(
      builder: (_) {
        return Container(
          width: Get.width * 0.80,
          // height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(Get.find<LanguageController>().languages.length, (
                index,
              ) {
                // final lang = Get.find<LanguageController>().languages[index];
                return Obx(
                  () => RadioListTile(
                    value:
                        Get.find<LanguageController>()
                            .languages[index]
                            .languageName,
                    groupValue: controller.selectedLanguage.value,
                    onChanged: (val) {
                      controller.selectedLanguage.value = val!;
                    },
                    contentPadding: EdgeInsets.zero,
                    fillColor: MaterialStateProperty.all(primaryBlackColor),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    title: Row(
                      children: [
                        CustomText(
                          text:
                              Get.find<LanguageController>()
                                  .languages[index]
                                  .languageName,
                          color: primaryBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                        ),
                        Spacer(),
                        // Image.asset(
                        //   'assets/extra_images/english.png',
                        //   height: 16,
                        // ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              CustomButton(
                text: "Save".tr.toUpperCase(),
                onPressed: () {
                  final localizationController =
                      Get.find<LocalizationController>();

                  if (controller.selectedLanguage.value == 'English') {
                    localizationController.setLanguage(Locale('en', 'US'));
                  } else if (controller.selectedLanguage.value == 'Arabic') {
                    localizationController.setLanguage(Locale('ar', 'Ar'));
                  }

                  Get.back();
                },
                backgroundColor: primaryBlackColor,
                textColor: whiteColor,
                minWidth: double.infinity,
              ),
            ],
          ),
        );
      },
    ),
  );
}

showChangePasswordDialog(ProfileController controller) {
  // Get.dialog(
  return AlertDialog(
    backgroundColor: Colors.white,
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Center(
      child: CustomText(
        text: 'Change Password'.tr,
        color: primaryBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: "Roboto",
      ),
    ),
    content: Container(
      width: Get.width * 0.80, // 95% of screen width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomTextField(
              hintText: "Current Password".tr,
              // textEditingController: controller.nameController,
              onChanged: (p0) => controller.name.value = p0!,
              obscureText: controller.isObscure.value,
              isBorder: true,
              shadowColor: primaryBlackColor,

              fillColor: Colors.transparent,
              borderColor: primaryBlackColor,

              suffixIcon: IconButton(
                icon: Icon(
                  controller.isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: primaryBlackColor,
                ),
                onPressed:
                    () =>
                        controller.isObscure.value =
                            !controller.isObscure.value,
              ),
            ),
          ),
          SizedBox(height: 16),
          Obx(
            () => CustomTextField(
              hintText: "New Password".tr,
              // textEditingController: controller.nameController,
              onChanged: (val) => controller.newPassword.value = val!,
              obscureText: controller.isObscureNew.value,
              isBorder: true,
              shadowColor: primaryBlackColor,

              fillColor: Colors.transparent,
              borderColor: primaryBlackColor,

              suffixIcon: IconButton(
                icon: Icon(
                  controller.isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: primaryBlackColor,
                ),
                onPressed:
                    () =>
                        controller.isObscureNew.value =
                            !controller.isObscureNew.value,
              ),
            ),
          ),
          SizedBox(height: 16),
          Obx(
            () => CustomTextField(
              hintText: "Confirm New Password".tr,
              // textEditingController: controller.nameController,
              obscureText: controller.isObscureConfirm.value,
              onChanged: (val) => controller.confirmPassword.value = val!,
              isBorder: true,
              shadowColor: primaryBlackColor,

              fillColor: Colors.transparent,
              borderColor: primaryBlackColor,

              suffixIcon: IconButton(
                icon: Icon(
                  controller.isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: primaryBlackColor,
                ),
                onPressed:
                    () =>
                        controller.isObscureConfirm.value =
                            !controller.isObscureConfirm.value,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: CustomButton(
                  text: "Save".tr.toUpperCase(),
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: primaryBlackColor,
                  textColor: whiteColor,
                  elevation: 0,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  minWidth: double.infinity,
                ),
              ),
              Expanded(
                child: CustomButton(
                  text: "Cancel".tr.toUpperCase(),
                  onPressed: () {
                    Get.back();
                  },

                  // backgroundColor: primaryBlackColor,
                  elevation: 0,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: primaryBlackColor,
                  borderColor: primaryBlackColor,
                  showBorder: true,

                  minWidth: double.infinity,
                ),
              ),
            ],
          ),
        ],
      ),
    ),

    // ),
  );
}

Widget languagePopupMenu(LanguageController languageController) {
  return GestureDetector(
    child: PopupMenuButton<int>(
      onSelected: (int newIndex) {
        languageController.setSelectIndex(newIndex);
        if (languageController.languages.isNotEmpty &&
            languageController.selectIndex != -1) {
          Get.find<LocalizationController>().setLanguage(
            Locale(
              AppConstants
                  .languages[languageController.selectIndex]
                  .languageCode,
              AppConstants
                  .languages[languageController.selectIndex]
                  .countryCode,
            ),
          );
          // if (fromHomeScreen) {
          //   Navigator.pop(Get.context!);
          // } else {
          //   // Get.to(LoginScreen());
          // }
        } else {
          // showCustomSnackBar('select_a_language'.tr);
        }
      },
      itemBuilder: (BuildContext context) {
        return languageController.languages.map((LanguageModel language) {
          int index = languageController.languages.indexOf(language);
          return PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                // Image.asset(language.imageUrl, width: 34, height: 34),
                const SizedBox(width: 10),
                Text(language.languageName),
              ],
            ),
          );
        }).toList();
      },
      child: Align(
        alignment:
            AppConstants
                            .languages[languageController.selectIndex]
                            .languageName ==
                        'Arabic' ||
                    AppConstants
                            .languages[languageController.selectIndex]
                            .languageName ==
                        'Hebrew'
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              languageController.selectIndex == -1
                  ? 'Select a Language'.tr
                  : languageController
                      .languages[languageController.selectIndex]
                      .languageName,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    ),
  );
}
