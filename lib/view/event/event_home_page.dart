import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/controller/event_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/auth/stated_page.dart';
import 'package:mushiya_beauty/view/event/event_details_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class EventHomePage extends StatelessWidget {
  EventHomePage({super.key});
  final controller = Get.put(EventController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Events".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body:
          FirebaseAuth.instance.currentUser == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Please login to access events",
                      fontSize: 16,
                      color: whiteColor,
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        Get.to(() => StatedPage());
                      },
                      backgroundColor: whiteColor,
                      textColor: primaryBlackColor,
                      fontSize: 14,
                      minWidth: double.infinity,
                      fontWeight: FontWeight.w600,
                      height: 48,
                    ),
                  ],
                ),
              )
              : Obx(() {
                if (controller.eventList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.eventList.length,
                  itemBuilder: (context, index) {
                    final event = controller.eventList[index];
                    // final order = controller.orders[index];
                    return GestureDetector(
                      onTap:
                          () =>
                              Get.to(() => EventDetailsPage(eventModel: event)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          // elevation: 0,
                          padding: EdgeInsets.only(bottom: 12, top: 0),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border(
                              bottom: BorderSide(
                                color: whiteColor.withOpacity(0.6),
                                width: 0.2,
                              ),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  event.image,
                                  width: double.infinity,
                                  height: 154,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 12,
                                ),
                                child: Column(
                                  spacing: 1,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: event.title,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: primaryBlackColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: DateFormat(
                                            'MMM',
                                          ).format(event.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: primaryBlackColor.withOpacity(
                                            0.60,
                                          ),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                        SizedBox(width: 24),
                                        Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: primaryBlackColor.withOpacity(
                                            0.60,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        CustomText(
                                          text: DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(event.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: primaryBlackColor.withOpacity(
                                            0.60,
                                          ),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: primaryBlackColor.withOpacity(
                                            0.60,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        CustomText(
                                          text: DateFormat(
                                            'hh:mm a',
                                          ).format(event.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: primaryBlackColor.withOpacity(
                                            0.60,
                                          ),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    CustomText(
                                      text: event.locations,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: primaryBlackColor.withOpacity(
                                        0.60,
                                      ),
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                    SizedBox(height: 5),
                                    CustomText(
                                      text: "From: \$" + event.ticket,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: primaryBlackColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    // CustomText(
                                    //   text: "3 items",
                                    //   // style: Goo(
                                    //   fontFamily: "Roboto",
                                    //   fontSize: 12,
                                    //   color: whiteColor.withOpacity(0.80),
                                    //   fontWeight: FontWeight.w400,
                                    //   // ),
                                    // ),
                                    // CustomText(
                                    //   // ignore: prefer_interpolation_to_compose_strings
                                    //   text: 'Order Date ' + order['date'],
                                    //   // style: Goo(
                                    //   fontFamily: "Roboto",
                                    //   fontSize: 12,
                                    //   color: whiteColor.withOpacity(0.80),
                                    //   fontWeight: FontWeight.w400,
                                    //   // ),
                                    // ),
                                  ],
                                ),
                              ),
                              // Spacer(),
                              // Column(
                              //   spacing: 19,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     // CustomText(
                              //     //   text: "Order ID " + "#" + order['id'],
                              //     //   // style: Goo(
                              //     //   fontFamily: "Roboto",
                              //     //   fontSize: 14,
                              //     //   color: whiteColor,
                              //     //   fontWeight: FontWeight.w500,
                              //     //   // ),
                              //     // ),
                              //     GestureDetector(
                              //       onTap: () => controller.viewDetails(order),
                              //       child: CustomText(
                              //         text: 'View details',
                              //         // style: Goo(
                              //         fontFamily: "Roboto",
                              //         fontSize: 12,
                              //         color: whiteColor,
                              //         decoration: TextDecoration.underline,
                              //         fontWeight: FontWeight.w400,
                              //         // ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
    );
  }
}
