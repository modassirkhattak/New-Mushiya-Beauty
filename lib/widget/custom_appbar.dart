import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/cart/cart_page.dart';
import 'package:mushiya_beauty/view/notificationn/notification_page.dart'
    show NotificationPage;
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

class MyAppBarWidget extends StatelessWidget {
  const MyAppBarWidget({
    super.key,
    this.title,
    this.actions,
    this.actionsWidget,
    this.titleImage,
    this.leadingButton,
  });

  final String? title;
  final bool? actions;
  final bool? leadingButton;
  final bool? titleImage;
  final Widget? actionsWidget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: whiteColor,
      actionsPadding: EdgeInsets.only(right: 16),
      elevation: 0,
      leading:
          leadingButton == true
              ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              )
              : IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
      centerTitle: true,
      title:
          titleImage == true
              ? CustomText(
                text: title.toString(),
                fontSize: 24,
                fontFamily: 'Archivo',
                color: whiteColor,
                fontWeight: FontWeight.w600,
              )
              : Image(
                image: AssetImage('assets/extra_images/app_logo.png'),
                height: 40,
              ),
      actions:
          actions == true
              ? [actionsWidget ?? Container()]
              : [
                GestureDetector(
                  onTap: () {
                    Get.to(() => CartInfo());
                  },
                  child: SvgPicture.asset(
                    'assets/icons_svg/cart_icon.svg',
                    color: whiteColor,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const NotificationPage());
                  },
                  child: SvgPicture.asset(
                    'assets/icons_svg/notification.svg',
                    color: whiteColor,
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
    );
  }
}
