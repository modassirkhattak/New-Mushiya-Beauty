import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/custom_textfield.dart';
import 'package:svg_flutter/svg.dart';

class MyRefferalsPage extends StatelessWidget {
  const MyRefferalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Referrals".toUpperCase(),
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
                text: "Give friends \$10, get \$10",
                color: whiteColor,
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40),
            Center(child: SvgPicture.asset("assets/icons_svg/referrals.svg")),
            SizedBox(height: 40),
            CustomTextField(
              hintText: "Referral code ",
              textEditingController: TextEditingController(),
              isBorder: true,
              textColor: whiteColor,
              fillColor: Colors.transparent,
              borderColor: whiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 40),
            CustomButton(
              text: "Share",
              onPressed: () {},
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              minWidth: double.infinity,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
