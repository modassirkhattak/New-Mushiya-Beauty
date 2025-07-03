import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/view/rewards/invite_referral_page.dart';
import 'package:mushiya_beauty/view/rewards/ways_earn_page.dart';
import 'package:mushiya_beauty/view/rewards/ways_to_redeam_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class RewardStartPage extends StatelessWidget {
  const RewardStartPage({super.key});

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
          title: "Rewards".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Column(
        spacing: 16,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 165,
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlackColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  whiteColor.withOpacity(0.20), // Orange
                  // Color(0xFF800080),
                  //// Purple
                  primaryBlackColor.withOpacity(0.10), // Blue
                  Colors.black54..withOpacity(0.50), // Blue
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: whiteColor.withOpacity(0.60),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomText(
              text: "Mushiya Bucks balance - 400",
              fontFamily: "Archivo",
              fontSize: 18,
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            spacing: 16,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(() => WaysEarnPage()),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    height: 164,
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: whiteColor,

                      border: Border.all(
                        color: whiteColor.withOpacity(0.60),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryBlackColor,
                          radius: 20,
                          child: SvgPicture.asset(
                            "assets/icons_svg/ways_eran.svg",
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomText(
                          text: "Ways to Earn",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "Earn Mushiya Bucks by shopping",
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(() => WaysToRedeamPage()),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    height: 164,
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: whiteColor,

                      border: Border.all(
                        color: whiteColor.withOpacity(0.60),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryBlackColor,
                          radius: 20,
                          child: SvgPicture.asset(
                            "assets/icons_svg/reward.svg",
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomText(
                          text: "Ways to Redeem",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "Redeem your Mushiya Bucks",
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => MyRefferalsPage());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 164,
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,

                border: Border.all(
                  color: whiteColor.withOpacity(0.60),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryBlackColor,
                    radius: 20,
                    child: SvgPicture.asset(
                      "assets/icons_svg/refrall_code.svg",
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: "Referrals",
                    fontFamily: "Roboto",
                    fontSize: 14,
                    color: primaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    text: "Invite friends to earn more",
                    fontFamily: "Roboto",
                    fontSize: 12,
                    color: primaryBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
