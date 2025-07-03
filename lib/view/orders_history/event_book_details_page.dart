import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mushiya_beauty/model/booked_event_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:intl/intl.dart';
class EventBookDetailsPage extends StatelessWidget {
  //  OrderDetailsPage({super.key});
  final BookedEventModel order;
  final String title;

  const EventBookDetailsPage({
    super.key,
    required this.order,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = order.created_at.toDate();
    return Scaffold(
      // backgroundColor: greyColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "${title}".toUpperCase(),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.white,
              ),
              padding: EdgeInsets.all(6),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(order.event.image),
                    height: 75,
                    width: 88,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: order.event.title,
                        fontSize: 14,
                        fontFamily: "Roboto",
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                      // CustomText(
                      //   text: "Mushiya beauty salon",
                      //   fontSize: 12,
                      //   fontFamily: "Archivo",
                      //   color: whiteColor.withOpacity(0.80),
                      //   fontWeight: FontWeight.w400,
                      // ),
                    ],
                  ),
                  // Spacer(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 2,
                  //     horizontal: 8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(4),
                  //     color: Colors.orangeAccent,
                  //   ),
                  //   child: CustomText(
                  //     text: "Active",
                  //     fontSize: 12,
                  //     fontFamily: "Roboto",
                  //     color: whiteColor,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Container(
              // padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryBlackColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  // spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: whiteColor, thickness: 0.5),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Date and time",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          // text: "Wednesday- 22 oct, 11:00 AM",
                          text: DateFormat("EEE - dd MMM, hh:mm a").format(dateTime),
                          // fontSize: 12,
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: whiteColor.withOpacity(0.80),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: whiteColor, thickness: 0.5),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Seats",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: order.bookedTicket,
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: whiteColor.withOpacity(0.80),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: whiteColor, thickness: 0.5),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Location",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: order.event.locations,
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: whiteColor.withOpacity(0.80),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: whiteColor, thickness: 0.5),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Bill",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "\$${order.event.ticket}",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: whiteColor.withOpacity(0.80),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: whiteColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Payment method",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CircleAvatar(
                          backgroundColor: whiteColor,
                          child: Icon(
                            Icons.credit_card,
                            color: primaryBlackColor,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: whiteColor, thickness: 0.5),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
