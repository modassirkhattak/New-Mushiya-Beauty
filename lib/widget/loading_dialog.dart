import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

loadingDialog({String? message, bool loading = false, bool button = false}) {
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: whiteColor,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: loading ? 20 : 0),
                    loading
                        ? const CircularProgressIndicator(
                          color: primaryBlackColor,
                        )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    message != null
                        ? SizedBox(
                          width: Get.width * 0.6,
                          child: CustomText(
                            text: "$message".tr,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: primaryBlackColor,
                            // alignment: Alignment.center,
                            textAlign: TextAlign.center,
                            fontFamily: 'Roboto',
                          ),
                        )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    button
                        ? CustomButton(
                          text: "Okay".tr,
                          // borderRadi/us:/ 10,
                          minWidth: 100,
                          height: 40,
                          onPressed: () {
                            Get.back();
                          },
                        )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
