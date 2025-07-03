import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';

void customAlertDialog(
  String title,
  String content, {
  Function()? onTap,
  bool showYesNoBtn = false,
}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsAlignment: MainAxisAlignment.center,
        title: Container(
          padding: const EdgeInsets.all(15),
          // width: Get.width,
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Text(
            "$title".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,

              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
        content: Text(
          "$content".tr,
          style: const TextStyle(
            fontSize: 14,

            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        actions:
            showYesNoBtn
                ? [
                  CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: 'Not'.tr,
                    // verticalPadding: 8,
                    minWidth: 50,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomButton(

                    onPressed:
                        onTap ??
                        () {
                          Get.back();
                        },
                    text: 'Yes'.tr,
                    // verticalPadding: 8,
                    minWidth: 50,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ]
                : [
                  CustomButton(
                    onPressed:
                        onTap ??
                        () {
                          Get.back();
                        },
                    text: 'Ok'.tr,

                    // verticalPadding: 8,
                    minWidth: 50,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
      );
    },
  );
}
