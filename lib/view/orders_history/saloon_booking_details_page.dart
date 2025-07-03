import 'package:flutter/material.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';

class SaloonBookingDetailsPage extends StatelessWidget {
  //  OrderDetailsPage({super.key});
  final Map<String, dynamic> order;
  final String title;

  const SaloonBookingDetailsPage({
    super.key,
    required this.order,
    required this.title,
  });
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
                itemCount: 2,
                shrinkWrap: true,
                // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                itemBuilder: (context, index) {
                  // final item = ;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.white,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage("${order['image']}"),
                          height: 75,
                          width: 88,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "${order['name']}",
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: "Mushiya beauty salon",
                              fontSize: 12,
                              fontFamily: "Archivo",
                              color: whiteColor.withOpacity(0.80),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orangeAccent,
                          ),
                          child: CustomText(
                            text: "Active",
                            fontSize: 12,
                            fontFamily: "Roboto",
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
                          text: "Date and time",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "Wednesday- 22 oct, 11:00 AM",
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
                          text: "Contact us",
                          fontSize: 14,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CircleAvatar(
                          backgroundColor: whiteColor,
                          child: Icon(Icons.phone, color: primaryBlackColor),
                        ),
                      ],
                    ),
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
                          text: "\$30",
                          fontSize: 16,
                          fontFamily: "Roboto",
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
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
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(color: whiteColor),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Payment Details",
                            fontSize: 14,
                            fontFamily: "Roboto",
                            color: primaryBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Deposit",
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: primaryBlackColor.withOpacity(0.60),
                                fontWeight: FontWeight.w400,
                              ),
                              CustomText(
                                text: "\$20",
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: primaryBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Grand Total",
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: primaryBlackColor.withOpacity(0.60),
                                fontWeight: FontWeight.w400,
                              ),
                              CustomText(
                                text: "\$20",
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
                                text: "Total",
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: primaryBlackColor.withOpacity(0.60),
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(
                                text: "\$200",
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: primaryBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
