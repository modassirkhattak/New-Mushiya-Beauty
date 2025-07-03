import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/product_details_controller.dart';
import 'package:mushiya_beauty/model/home_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';

import 'package:mushiya_beauty/widget/custom_text.dart';

class TheCeoPage extends StatelessWidget {
  TheCeoPage({super.key});

  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   materialTapTargetSize: MaterialTapTargetSize.padded,
        //   // mini: true,
        //   shape: const CircleBorder(),
        //   backgroundColor: whiteColor,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SvgPicture.asset(
        //       'assets/icons_svg/message_icon2.svg',
        //       height: 24,
        //       width: 24,
        //     ),
        //   ),
        // ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            title: "The CEO".toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget:
                null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
            leadingButton: true,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              CustomText(
                text: 'Inspiring Journey of Mushiya: Founder of Mushiya Beauty',
                maxLines: 2,
                fontSize: 18,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w600,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/extra_images/ceo_image.png',
                  height: 320,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              CustomText(
                text:
                    'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
                fontSize: 12,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w400,
                maxLines: 30,
              ),
              CustomText(
                text: 'A Legacy of Innovation',
                maxLines: 2,
                fontSize: 18,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text:
                    "Born in Congo and educated across Zimbabwe, Missouri, and Montreal, Canada, Mushiya holds a degree in Business and Psychology from Concordia University. Her true passion, however, lies in empowering women and spreading the Natural Hair Movement. As an activist and serial entrepreneur, Mushiya has revolutionized the hair industry, particularly in Atlanta and beyond.",
                // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
                fontSize: 12,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w400,
                maxLines: 30,
              ),
              CustomText(
                text:
                    "Born in Congo and educated across Zimbabwe, Missouri, and Montreal, Canada, Mushiya holds a degree in Business and Psychology from Concordia University. Her true passion, however, lies in empowering women and spreading the Natural Hair Movement. As an activist and serial entrepreneur, Mushiya has revolutionized the hair industry, particularly in Atlanta and beyond.",
                // 'Mushiya, a name synonymous with innovation and leadership in the beauty industry, is a Senior Business Consultant for Zufire and the CEO, Founder, and Creative Director of several successful brands, including Runway Curls Salon Suites, Mushiya Beauty, The Damn Salon, and My Natural Doll. With over 20 years of experience, Mushiya has become a branding guru, setting new trends and standards in the industry, and her influence on beauty professionals is both impactful and undeniable.',
                fontSize: 12,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w400,
                maxLines: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabbarView({required HomeModel homeModel, required String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      CustomText(
        text: title,
        fontSize: 18,
        fontFamily: 'Archivo',
        color: whiteColor,
        fontWeight: FontWeight.w600,
      ),
      CustomText(
        text:
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla. ',
        fontSize: 12,
        fontFamily: 'Roboto',
        color: whiteColor,
        maxLines: 90,
        fontWeight: FontWeight.w400,
      ),
    ],
  );
}
