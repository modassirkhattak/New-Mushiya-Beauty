import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mushiya_beauty/controller/event_controller.dart';
import 'package:mushiya_beauty/model/event_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/payment/payment_selection_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_dropdown.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';

// ignore: must_be_immutable
class EventDetailsPage extends StatelessWidget {
  EventDetailsPage({super.key, required this.eventModel});
  final controller = Get.put(EventController());

  EventModel eventModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Event details".toUpperCase(),
          titleImage: true,
          actions: true,
          actionsWidget: SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              // onTap: () => controller.viewDetails(order),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  // elevation: 0,
                  padding: EdgeInsets.only(bottom: 12, top: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: whiteColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              eventModel.image,
                              width: double.infinity,
                              height: 320,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                backgroundBlendMode: BlendMode.hardLight,
                                border: Border.all(color: whiteColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.60),
                                    blurRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    primaryBlackColor,
                                    primaryBlackColor.withOpacity(0.30),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 20,
                                ),
                                child: Column(
                                  spacing: 1,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: eventModel.title,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: DateFormat(
                                            'MMM',
                                          ).format(eventModel.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.60),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                        SizedBox(width: 24),
                                        Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: whiteColor.withOpacity(0.60),
                                        ),
                                        SizedBox(width: 8),
                                        CustomText(
                                          text: DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(eventModel.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.60),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: whiteColor.withOpacity(0.60),
                                        ),
                                        SizedBox(width: 8),
                                        CustomText(
                                          text: DateFormat(
                                            'hh:mm a',
                                          ).format(eventModel.dateTime),
                                          // style: Goo(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.60),
                                          fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    CustomText(
                                      text: eventModel.locations,
                                      // style: Goo(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.60),
                                      fontWeight: FontWeight.w400,
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomText(
              text: "Tickets: \$${eventModel.ticket} ",
              fontSize: 18,
              fontFamily: 'Archivo',
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 16),
            CustomDropdown(
              hintText: "Tickets",
              items: List.generate(20, (index) => (index + 1).toString()),
              selectedValue: controller.selectedEventTicket.value.obs,

              onChanged: (value) {
                controller.selectedEventTicket.value = value!;
              },
            ),
            SizedBox(height: 16),
            CustomText(
              text: "Details",
              fontSize: 18,
              fontFamily: 'Archivo',
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 16),
            CustomText(
              text: eventModel.description,
              fontSize: 12,
              fontFamily: 'Roboto',
              color: whiteColor,
              fontWeight: FontWeight.w400,
              maxLines: 10,
            ),
            SizedBox(height: 30),
            CustomButton(
              text: "Reserve now".toUpperCase(),
              onPressed: () {
                if(controller.selectedEventTicket.value.isEmpty){
                  Get.snackbar(
                    "Error",
                    "Please select a ticket",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );

                } else{
                  EventModel(
                    id: eventModel.id,
                    title: eventModel.title,
                    dateTime: eventModel.dateTime,
                    locations: eventModel.locations,
                    description: eventModel.description,
                    ticket: eventModel.ticket,
                    image: eventModel.image,
                  );
                  Get.to(
                        () => PaymentSelectionPage(
                      selectedPaymentMethod: "Event",
                      eventModel: eventModel,
                    ),
                  );
                }

              },
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              elevation: 0,
              fontSize: 16,
              height: 48,
              fontWeight: FontWeight.w600,
              minWidth: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
