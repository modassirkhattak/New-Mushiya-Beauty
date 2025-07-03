import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart' show MyAppBarWidget;
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Notification".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: null,
          leadingButton: true,
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: Container(
              width: double.infinity,
              // height: 100,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(color: whiteColor, width: 0.1),
                ),
                // color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons_svg/notification_back.svg',
                            height: 36,
                            width: 36,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/icons_svg/notification_p_icon.svg',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Notification",
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text:
                                  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              maxLines: 2,
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      CustomText(
                        text: "5 min ago",
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
