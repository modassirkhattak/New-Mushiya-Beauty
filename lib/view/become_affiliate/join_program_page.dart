import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/sign_up_provider.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/payment/payment_selection_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_checkbox.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';

class JoinProgramPage extends StatelessWidget {
  const JoinProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Join Program".tr.toUpperCase(),
          titleImage: true,
          actions: true,

          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: CustomText(
            //     text: "Become a Mushiya Affiliate",
            //     color: whiteColor,
            //     fontFamily: "Roboto",
            //     fontSize: 18,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Center(
            //     child: CustomText(
            //       text:
            //           "Share your love for Mushiya and earn commission on every sale made through your link!",
            //       color: whiteColor,
            //       fontFamily: "Roboto",
            //       maxLines: 3,
            //       textAlign: TextAlign.center,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 40),
            // Center(
            //   child: SvgPicture.asset("assets/icons_svg/Become affiliate.svg"),
            // ),
            // SizedBox(height: 40),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "First name".tr,
                    textEditingController: TextEditingController(),
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    hintText: "Last name".tr,
                    textEditingController: TextEditingController(),
                    isBorder: true,
                    textColor: whiteColor,
                    fillColor: Colors.transparent,
                    borderColor: whiteColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CustomTextField(
              hintText: "Email".tr,
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 24),
            CustomTextField(
              hintText: "Phone number".tr,
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 24),
            CustomTextField(
              hintText: "Preferred payout method".tr,
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 24),
            CustomCheckboxWithText(
              isChecked: Get.put(SignUpProvider()).isAgree,
              color: whiteColor,
              textColor: whiteColor,

              onTap: () {
                //  controller.isAgree.value =
                // !controller.isAgree.value;
                Get.put(SignUpProvider()).isAgree.value =
                    !Get.put(SignUpProvider()).isAgree.value;
              },
            ),
            SizedBox(height: 40),
            CustomButton(
              text: "Continue".tr,
              onPressed: () {
                Get.to(PaymentSelectionPage(selectedPaymentMethod: "referral"));
              },
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              minWidth: double.infinity,
              height: 48,
            ),
            SizedBox(height: 24),
            Center(
              child: CustomText(
                text: "It’s free and easy to join".tr,
                color: whiteColor,
                fontFamily: "Roboto",
                maxLines: 3,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
