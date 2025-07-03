import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mushiya_beauty/controller/reward_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/rewards/invite_referral_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class WaysEarnPage extends StatelessWidget {
  WaysEarnPage({super.key});

  final controller = Get.put(RewardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Ways to earn".toUpperCase(),
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.rewardList.length,
              itemBuilder: (context, index) {
                final item = controller.rewardList[index];
                return Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  // height: 85,
                  alignment: Alignment.center,
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,

                    border: Border.all(
                      color: whiteColor.withOpacity(0.60),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // backgroundColor: primaryBlackColor,
                          // radius: 20,
                          decoration: BoxDecoration(
                            color: primaryBlackColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              // topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              // bottomRight: Radius.circular(10),
                            ),

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                                greyColor,
                                Colors.black87.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SvgPicture.asset(item.icon),
                          ),
                        ),
                        // SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: item.title,
                              // fontFamily: "Roboto",
                              // fontSize: 14,
                              // color: primaryBlackColor,
                              // fontWeight: FontWeight.w500,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,

                                color: primaryBlackColor,
                              ),
                            ),
                            CustomText(
                              text: item.subText,
                              fontFamily: "Roboto",
                              fontSize: 12,
                              color: primaryBlackColor.withOpacity(0.60),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: CustomButton(
              text: "Join Now".toUpperCase(),
              onPressed: () {
                Get.to(() => MyRefferalsPage());
              },
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              minWidth: double.infinity,
              height: 48,
              elevation: 0,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
