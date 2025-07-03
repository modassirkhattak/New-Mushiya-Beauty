import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/rewards/ways_earn_page.dart';
import 'package:mushiya_beauty/view/rewards/ways_to_redeam_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class BecomeAffiliatDashboardPage extends StatelessWidget {
  const BecomeAffiliatDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "My dashboard".toUpperCase(),
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
          Row(
            spacing: 10,
            children: [
              CustomText(
                text: "My referral link",
                fontFamily: "Roboto",
                fontSize: 14,
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
              GestureDetector(
                onTap: () {},
                child: CustomText(
                  text: "Https://mushiya.com/ref/",
                  fontFamily: "Roboto",
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.copy),
                color: whiteColor,
              ),
            ],
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
                        CustomText(
                          text: "Referred Users",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "12",
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
                        CustomText(
                          text: "Total sales",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "\$1234",
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
                        CustomText(
                          text: "Earnings",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "\$200",
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
                        CustomText(
                          text: "Current payout balance",
                          fontFamily: "Roboto",
                          fontSize: 14,
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "\$1234",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: CustomButton(
              text: "Request Payout",
              onPressed: () {},
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              height: 48,
              minWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
