import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/try_on/main.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/drawer_widget.dart';


class TryOnHomePage extends StatelessWidget {
  const TryOnHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          // title: ''.toUpperCase() ?? 'All products'.toUpperCase(),
          titleImage: false,
          actions: true,
          actionsWidget: null,
          leadingButton: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/extra_images/girl_1.png',
                height: 313,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: "Try On a Wig",
              // style: const TextStyle(
              color: whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Archivo',
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 78.0, top: 12),
              child: CustomText(
                text: "Use your phone to see how different wigs look on you. ",
                // style: const TextStyle(
                color: whiteColor.withOpacity(0.80),
                maxLines: 2,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                // ),
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: "Instructions",
              // style: const TextStyle(
              color: whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Archivo',
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 78.0, top: 12),
              child: CustomText(
                text:
                    "1. Make sure your face is visible. \n2. Use a well-lit room.",
                // style: const TextStyle(
                color: whiteColor.withOpacity(0.80),
                maxLines: 400,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                // ),
              ),
            ),
            SizedBox(height: 47),
            CustomButton(
              text: "Continue",
              onPressed: () {
                // Get.to(() => HairColorTryOnApp());
                Get.to(() => FaceDetectorView());
              },
              backgroundColor: whiteColor,
              height: 48,
              elevation: 0,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: primaryBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
