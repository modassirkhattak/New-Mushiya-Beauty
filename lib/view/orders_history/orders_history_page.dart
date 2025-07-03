import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/controller/order_history_controller.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/orders_history/event_book_details_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_tabbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    controller.fetchOrders();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            title: "Order History".toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget:
                null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
            leadingButton: true,
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(
                      () => Container(
                        alignment: Alignment.center,
                        padding:
                            controller.mainTab != 0
                                ? EdgeInsets.zero
                                : const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                        decoration: BoxDecoration(
                          color:
                              controller.mainTab == 0
                                  ? primaryBlackColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 12,
                        //   vertical: 8,
                        // ),
                        child: GestureDetector(
                          onTap: () => controller.setMainTab(0),
                          child: CustomText(
                            text: 'Order History',
                            // style: Goo(
                            fontFamily: "Roboto",
                            fontSize: 13,

                            color:
                                controller.mainTab == 0
                                    ? whiteColor
                                    : primaryBlackColor,
                            fontWeight:
                                controller.mainTab == 0
                                    ? FontWeight.w500
                                    : FontWeight.w500,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color:
                              controller.mainTab == 1
                                  ? primaryBlackColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        padding:
                            controller.mainTab != 1
                                ? EdgeInsets.zero
                                : const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                        child: GestureDetector(
                          onTap: () => controller.setMainTab(1),
                          child: CustomText(
                            text: 'Salon Booking',
                            // style: Goo(
                            fontFamily: "Roboto",
                            fontSize: 13,

                            color:
                                controller.mainTab == 1
                                    ? whiteColor
                                    : primaryBlackColor,
                            fontWeight:
                                controller.mainTab == 1
                                    ? FontWeight.w500
                                    : FontWeight.w500,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color:
                              controller.mainTab == 2
                                  ? primaryBlackColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        padding:
                            controller.mainTab != 2
                                ? EdgeInsets.zero
                                : const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                        child: GestureDetector(
                          onTap: () => controller.setMainTab(2),
                          child: CustomText(
                            text: 'Event Booking',
                            // style: Goo(
                            fontFamily: "Roboto",
                            fontSize: 13,

                            color:
                                controller.mainTab == 2
                                    ? whiteColor
                                    : primaryBlackColor,
                            fontWeight:
                                controller.mainTab == 2
                                    ? FontWeight.w500
                                    : FontWeight.w500,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            DefaultTabController(
              length: 2,
              child: CustomTabWidget(
                onTap: (index) => controller.setSubTab(index),
                children: [Tab(text: 'Active'), Tab(text: 'Completed')],
              ),
            ),
            SizedBox(height: 16),
            // if (controller.mainTab == 1)
            Expanded(
              child: Obx(() {
                if (controller.mainTab == 0) {
                  return Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(color: whiteColor),
                      );
                    }
                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.errorMessage.value),
                            ElevatedButton(
                              onPressed: controller.retryFetchOrders,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (controller.orders.isEmpty) {
                      return Center(child: Text('No orders found'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.ordersModel.length,
                      itemBuilder: (context, index) {
                        final order = controller.ordersModel[index];
                        return Container(
                          // elevation: 0,
                          padding: EdgeInsets.only(bottom: 12, top: 12),
                          decoration: BoxDecoration(
                            // color: primaryBlackColor,
                            border: Border(
                              bottom: BorderSide(
                                color: whiteColor.withOpacity(0.6),
                                width: 0.2,
                              ),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(10),
                              //   child: Image.asset(
                              //     order.lineItems[index].price,
                              //     width: 81,
                              //     height: 81,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  spacing: 1,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: order.lineItems[0].name,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      maxLines: 2,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    // CustomText(
                                    //   text: 'Deposit: \$400',
                                    //   // style: Goo(
                                    //   fontFamily: "Roboto",
                                    //   fontSize: 14,
                                    //   color: whiteColor,
                                    //   fontWeight: FontWeight.w500,
                                    //   // ),
                                    // ),
                                    CustomText(
                                      text:
                                          'Total: \$' +
                                          order.currentSubtotalPrice,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    CustomText(
                                      text:
                                          "${order.lineItems.map((e) => e.quantity).reduce((value, element) => value + element).toString()} items",
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.80),
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                    CustomText(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      text: 'Order Date ' + order.createdAt,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.80),
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                spacing: 19,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text:
                                        "Order ID " +
                                        "" +
                                        order.name.toString(),
                                    // style: Goo(
                                    fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                    // ),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        () => controller.viewDetails(
                                          order,
                                          tag: order.tags,
                                        ),
                                    child: CustomText(
                                      text: 'View details',
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: whiteColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  });
                } else if (controller.mainTab == 1) {
                  return StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection("BookedEvents")
                            .where(
                              'booked_by',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No evennts found'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.orders.length,
                        itemBuilder: (context, index) {
                          final order = controller.orders[index];
                          return Container(
                            // elevation: 0,
                            padding: EdgeInsets.only(bottom: 12, top: 12),
                            decoration: BoxDecoration(
                              // color: primaryBlackColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: whiteColor.withOpacity(0.6),
                                  width: 0.2,
                                ),
                              ),
                            ),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    order['image'],
                                    width: 81,
                                    height: 81,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  spacing: 1,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: order['name'],
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    CustomText(
                                      text: 'Deposit: \$400',
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    CustomText(
                                      text: "Price: " + order['price'],
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: whiteColor,
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
                                    CustomText(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      text: 'Order Date ' + order['date'],
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.80),
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  spacing: 19,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // CustomText(
                                    //   text: "Order ID " + "#" + order['id'],
                                    //   // style: Goo(
                                    //   fontFamily: "Roboto",
                                    //   fontSize: 14,
                                    //   color: whiteColor,
                                    //   fontWeight: FontWeight.w500,
                                    //   // ),
                                    // ),
                                    GestureDetector(
                                      // onTap: () => controller.viewDetails(order),
                                      child: CustomText(
                                        text: 'View details',
                                        // style: Goo(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: whiteColor,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w400,
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (controller.mainTab == 2) {
                  return Obx(() {
                    if (controller.bookedEvents.isEmpty) {
                      return const Center(child: Text("No bookings found."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        // vertical: 10,
                      ),
                      itemCount: controller.bookedEvents.length,
                      itemBuilder: (context, index) {
                        final order = controller.bookedEvents[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16, top: 12),
                          child: GestureDetector(
                            onTap:
                                () => Get.to(
                                  () => EventBookDetailsPage(
                                    order: order,
                                    title: "Event bookings",
                                  ),
                                ),
                            child: Container(
                              // elevation: 0,
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
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      order.event.image,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: order.event.title,
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
                                            Icon(
                                              Icons.calendar_month,
                                              size: 16,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                            ),
                                            SizedBox(width: 8),
                                            CustomText(
                                              text: DateFormat(
                                                'yyyy/MM/dd',
                                              ).format(DateTime.now()),
                                              // style: Goo(
                                              fontFamily: "Roboto",
                                              fontSize: 12,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                              fontWeight: FontWeight.w400,
                                              // ),
                                            ),
                                            SizedBox(width: 24),
                                            Icon(
                                              Icons.timelapse,
                                              size: 16,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                            ),
                                            SizedBox(width: 8),
                                            CustomText(
                                              text: DateFormat(
                                                'hh:mm a',
                                              ).format(DateTime.now()),
                                              // style: Goo(
                                              fontFamily: "Roboto",
                                              fontSize: 12,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                              fontWeight: FontWeight.w400,
                                              // ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_city,
                                              size: 16,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                            ),
                                            SizedBox(width: 8),
                                            CustomText(
                                              text:
                                                  "2972 Westheimer Rd. Santa Ana",
                                              // style: Goo(
                                              fontFamily: "Roboto",
                                              fontSize: 12,
                                              color: primaryBlackColor
                                                  .withOpacity(0.60),
                                              fontWeight: FontWeight.w400,
                                              // ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        CustomText(
                                          text: "Price: " + order.event.ticket,
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
                  });
                }
                return Text("data");
              }),
            ),
          ],
        ),
      ),
    );
  }
}
