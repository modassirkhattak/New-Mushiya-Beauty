import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/model/event_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/bottom_bar/bottom_bar_page.dart';
import 'package:mushiya_beauty/view/payment/become_affiliat_dashboard_page.dart';
import 'package:mushiya_beauty/view/whole_sale/whole_sale_page.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

import '../controller/cart_controller.dart';

class ResetLinkDialog extends StatelessWidget {
  const ResetLinkDialog({
    super.key,
    this.text,
    this.iconPath,
    this.condition,
    this.image,
    this.maxLine,
    this.textName,
  });

  final String? text;
  final String? iconPath;
  final String? textName;
  final String? condition;
  final bool? image;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image == false
                ? CustomText(
                  text: textName ?? "Reset Link",
                  // leftPadding: 8,
                  // topPadding: 4,
                  // rightPadding: 8,
                  // bottomPadding: 4,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  fontFamily: "Archivo",
                  color: primaryBlackColor,
                )
                : SvgPicture.asset(
                  iconPath ?? 'assets/icons_svg/send_airo_icon.svg',

                  color: Colors.black87,
                ),
            const SizedBox(height: 24),
            CustomText(
              text:
                  text ??
                  'A reset link has been emailed to you. Please also check your spam.',
              textAlign: TextAlign.center,
              // style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              maxLines: maxLine ?? 2,
              fontWeight: FontWeight.w400,
              // color: Colors.black87,
              // ),
            ),
            if (condition == "order_success" ||
                condition == "request_success" ||
                condition == "signup_done" ||
                condition == "become_affiliate" ||
                condition == "booked_service")
              const SizedBox(height: 24),
            if (condition == "order_success" ||
                condition == "request_success" ||
                condition == "become_affiliate" ||
                condition == "signup_done" ||
                condition == "booked_service")
              CustomButton(
                text: "Okay".toUpperCase(),
                backgroundColor: primaryBlackColor,
                textColor: whiteColor,
                elevation: 0,
                height: 40,
                minWidth: 160,
                onPressed: () {
                  if (condition == "order_success") {
                    // Get.back();
                    Get.find<CartController>().cartItems.clear();
                    Get.offAll(() => BottomBarPage());
                  } else if (condition == "request_success") {
                    Get.to(() => WholeSalePage());
                  } else if (condition == "become_affiliate") {
                    Get.to(() => BecomeAffiliatDashboardPage());
                  } else if (condition == "booked_service") {
                    Get.back();
                  } else if (condition == "signup_done") {
                    Get.to(() => BottomBarPage());
                  } else {
                    Get.back();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class EventBookedDialog extends StatelessWidget {
  const EventBookedDialog({
    super.key,
    this.text,
    this.iconPath,
    this.condition,
    this.image,
    this.maxLine,
    this.textName,
    required this.eventModel,
  });

  final String? text;
  final String? iconPath;
  final String? textName;
  final String? condition;
  final bool? image;
  final int? maxLine;
  final EventModel? eventModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            image == false
                ? Center(
                  child: CustomText(
                    text: textName ?? "Reset Link",
                    // leftPadding: 8,
                    // topPadding: 4,
                    // rightPadding: 8,
                    // bottomPadding: 4,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    fontFamily: "Archivo",
                    color: primaryBlackColor,
                  ),
                )
                : Center(
                  child: SvgPicture.asset(
                    iconPath ?? 'assets/icons_svg/send_airo_icon.svg',

                    color: Colors.black87,
                  ),
                ),
            const SizedBox(height: 24),
            Center(
              child: CustomText(
                text:
                    text ??
                    'A reset link has been emailed to you. Please also check your spam.',
                textAlign: TextAlign.center,
                // style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                maxLines: maxLine ?? 2,
                fontWeight: FontWeight.w400,
                // color: Colors.black87,
                // ),
              ),
            ),
            if (condition == "order_success" ||
                condition == "request_success" ||
                condition == "become_affiliate" ||
                condition == "booked_service")
              const SizedBox(height: 24),
            if (condition == "order_success" ||
                condition == "request_success" ||
                condition == "become_affiliate" ||
                condition == "booked_service")
              Center(
                child: CustomButton(
                  text: "Okay".toUpperCase(),
                  backgroundColor: primaryBlackColor,
                  textColor: whiteColor,
                  elevation: 0,
                  height: 40,
                  minWidth: 160,
                  onPressed: () {
                    if (condition == "become_affiliate") {
                      Get.offAll(() => BottomBarPage());
                    }
                    Get.back();
                  },
                ),
              ),
            const SizedBox(height: 24),
            CustomText(
              text: "Price: \$${eventModel!.ticket}",
              fontSize: 14,
              fontFamily: "Roboto",
              leftPadding: 8,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
              child: Divider(color: primaryBlackColor, thickness: 0.4),
            ),
            CustomText(
              text: "Tickets: ${eventModel!.description}",
              fontSize: 14,
              fontFamily: "Roboto",
              leftPadding: 8,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
              child: Divider(color: primaryBlackColor, thickness: 0.4),
            ),
            CustomText(
              text: "Location: ${eventModel!.locations}",
              fontSize: 14,
              fontFamily: "Roboto",
              leftPadding: 8,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
              child: Divider(color: primaryBlackColor, thickness: 0.4),
            ),
            CustomText(
              text:
                  "Date: ${DateFormat('dd/MM/yyyy').format(eventModel!.dateTime)}",
              fontSize: 14,
              fontFamily: "Roboto",
              leftPadding: 8,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
              child: Divider(color: primaryBlackColor, thickness: 0.4),
            ),
            CustomText(
              text:
                  "Time: ${DateFormat('hh:mm a').format(eventModel!.dateTime)}",
              fontSize: 14,
              fontFamily: "Roboto",
              leftPadding: 8,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 20,
              child: Divider(color: primaryBlackColor, thickness: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
