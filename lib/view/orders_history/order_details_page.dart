import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/model/order_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:shopify_flutter/models/models.dart';

class OrderDetailsPage extends StatelessWidget {
  //  OrderDetailsPage({super.key});
  final Order order;
  final String title;

  const OrderDetailsPage({super.key, required this.order, required this.title});
  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                itemCount: order.lineItems.lineItemOrderList!.length,
                shrinkWrap: true,
                // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                itemBuilder: (context, index) {
                  final lineItems = order.lineItems!.lineItemOrderList![index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image(
                        //   image: AssetImage("${order.lineItems.first.image}"),
                        //   height: 75,
                        //   width: 88,
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "${lineItems.title}",
                              fontSize: 14,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text:
                                  "${lineItems.originalTotalPrice} x ${lineItems.quantity} = \$${lineItems.discountedTotalPrice}",
                              fontSize: 18,

                              fontFamily: "Archivo",
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Order summary",
                      fontSize: 16,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Order ID",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          text: "${order.name}",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text:
                              "Sub total (${"${order.subtotalPriceV2}"} items)",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          text: "\$${order.totalPriceV2}",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CustomText(
                    //       text: "Delivery",
                    //       fontSize: 12,
                    //       fontFamily: "Roboto",
                    //       color: primaryBlackColor.withOpacity(0.60),
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     CustomText(
                    //       text: "\$${order.currentTotalDutiesSet}",
                    //       fontSize: 12,
                    //       fontFamily: "Roboto",
                    //       color: primaryBlackColor,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ],
                    // ),
                    // Divider(color: primaryBlackColor, thickness: 0.5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CustomText(
                    //       text: "Discount",
                    //       fontSize: 12,
                    //       fontFamily: "Roboto",
                    //       color: primaryBlackColor.withOpacity(0.60),
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     CustomText(
                    //       text:
                    //           "\$${order.}", // order.currentTotalDiscounts,
                    //       fontSize: 12,
                    //       fontFamily: "Roboto",
                    //       color: primaryBlackColor,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ],
                    // ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Taxes",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          text: order.totalTaxV2.toString(),
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Total (${order.lineItems.lineItemOrderList.length} items)",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "\$${order.totalTaxV2}",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Payment method",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          text: "${order.financialStatus}",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(color: primaryBlackColor, thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Placed on",
                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor.withOpacity(0.60),
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          text:
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(order.fulfillmentStatus))
                                  .toString(),

                          fontSize: 12,
                          fontFamily: "Roboto",
                          color: primaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border(
                    //       bottom: BorderSide(
                    //         color: primaryBlackColor,
                    //         width: 0.5,
                    //         strokeAlign: 20,
                    //         style: BorderStyle.solid,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
