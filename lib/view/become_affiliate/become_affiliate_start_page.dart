import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/become_affiliate/join_program_page.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class BecomeAffiliateStartPage extends StatelessWidget {
  const BecomeAffiliateStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => FaqPage());
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        // mini: true,
        shape: const CircleBorder(),
        backgroundColor: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/icons_svg/message_icon2.svg',
            height: 24,
            width: 24,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Become affiliate".tr.toUpperCase(),
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
            Center(
              child: CustomText(
                text: "Become a Mushiya Affiliate".tr,
                color: whiteColor,
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomText(
                  text:
                      "Share your love for Mushiya and earn commission on every sale made through your link!".tr,
                  color: whiteColor,
                  fontFamily: "Roboto",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SvgPicture.asset(
                "assets/icons_svg/Become affiliate.svg",
                height: 172,
              ),
            ),
            // SizedBox(height: 40),
            // CustomTextField(
            //   hintText: "Referral code ",
            //   textEditingController: TextEditingController(),
            //   isBorder: true,
            //   fillColor: Colors.transparent,
            //   borderColor: whiteColor.withOpacity(0.3),
            // ),
            SizedBox(height: 40),
            CustomButton(
              text: "JOIN NOW".tr,
              onPressed: () {
                Get.to(JoinProgramPage());
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
