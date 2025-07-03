import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/checkout_controller.dart';
import 'package:mushiya_beauty/controller/event_controller.dart';
import 'package:mushiya_beauty/model/event_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_dialog.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:mushiya_beauty/widget/loading_dialog.dart';
import 'package:svg_flutter/svg.dart';

// ignore: must_be_immutable
class PaymentSelectionPage extends StatelessWidget {
  PaymentSelectionPage({
    super.key,
    required this.selectedPaymentMethod,
    this.eventModel,
  });
  final controller = Get.put(CheckoutController());
  final eventController = Get.put(EventController());

  EventModel? eventModel;

  final String selectedPaymentMethod;
  @override
  Widget build(BuildContext context) {
    // print(eventModel!.ticket);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MyAppBarWidget(
          title: "Payment".toUpperCase(),
          titleImage: true,
          actions: true,

          actionsWidget:
              null, // SvgPicture.asset('assets/icons_svg/share_icon.svg'),
          leadingButton: true,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 70 * 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:
                  controller.paymentMethods.map((method) {
                    return Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.selectedPaymentMethod.value =
                              method['name']!;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          // padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // color: pr,
                            // borderRadius: BorderRadius.circular(12),
                            border: Border(
                              bottom: BorderSide(
                                color: whiteColor.withOpacity(0.60),
                                width: 0.5,
                              ),
                              // color:
                              // controller.selectedPaymentMethod.value ==
                              //         method['name']
                              //     ? whiteColor
                              //     : whiteColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                              bottom: 5,
                              left: 12,
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: method['name']!,
                                  groupValue:
                                      controller.selectedPaymentMethod.value,
                                  activeColor: whiteColor,
                                  fillColor: MaterialStateProperty.all(
                                    whiteColor,
                                  ),
                                  onChanged: (value) {
                                    controller.selectedPaymentMethod.value =
                                        value!;
                                  },
                                ),
                                // const SizedBox(width: 12),
                                Expanded(
                                  child: CustomText(
                                    leftPadding: 0,
                                    text: method['name']!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                    color: whiteColor,
                                  ),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  method['icon']!,
                                  height: 17,
                                  width: 17,
                                  color: whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: CustomButton(
              text: "Confirm".toUpperCase(),

              onPressed: () {
                if (selectedPaymentMethod == "Event") {
                  if (controller.selectedPaymentMethod.value.isEmpty) {
                    Get.snackbar("Error", "Please select payment method");
                    return;
                  } else {
                    loadingDialog(
                      loading: true,
                      message: "Please wait a moment  ",
                    );
                    final amount =
                        int.parse(eventModel!.ticket) *
                        int.parse(eventController.selectedEventTicket.value);

                    final eventModelData = EventModel(
                      id: eventModel!.id,
                      title: eventModel!.title,
                      description: eventController.selectedEventTicket.value,
                      image: eventModel!.image,
                      locations: eventModel!.locations,
                      ticket: amount.toString(),
                      dateTime: DateTime.now(),
                    );

                    // print("eventController.selectedEventTicket.value");
                    // print(amount);
                    FirebaseFirestore.instance
                        .collection('BookedEvents')
                        .add({
                          'ticket': amount.toString(),
                          'booked': true,
                      "created_at": DateTime.now(),

                          'booked_ticket':
                              eventController.selectedEventTicket.value,
                          'booked_by': FirebaseAuth.instance.currentUser!.uid,
                          'booked_by_name':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'booked_by_email':
                              FirebaseAuth.instance.currentUser!.email,
                          'eventAll': eventModelData.toJson(),
                        })
                        .then((docRef) async {
                          // Fetch the added document
                          final addedDoc = await docRef.get();

                          // Set the model from Firestore
                          eventModel = EventModel.fromJson(
                            addedDoc['eventAll'],
                            id: addedDoc.id,
                          );

                          // Close loading dialog
                          Get.back();

                          // Show success dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            barrierColor: primaryBlackColor.withOpacity(0.8),
                            builder:
                                (context) => EventBookedDialog(
                                  eventModel: eventModel,
                                  text:
                                      "Your Ticket has been successfully booked",
                                  iconPath:
                                      "assets/icons_svg/done_check_icon.svg",
                                  condition: "become_affiliate",
                                ),
                          );
                        });
                  }
                } else if (selectedPaymentMethod == "Subscription") {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: primaryBlackColor.withOpacity(0.8),

                    builder:
                        (context) => const ResetLinkDialog(
                          text:
                              "Your payment methode is not enabled yet. comming soon",
                          iconPath: "assets/icons_svg/done_check_icon.svg",
                          condition: "order_success",
                        ),
                  );
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: primaryBlackColor.withOpacity(0.8),

                    builder:
                        (context) => const ResetLinkDialog(
                          text:
                              "Your payment methode is not available yet. comming soon",
                          iconPath: "assets/icons_svg/done_check_icon.svg",
                          condition: "become_affiliate",
                        ),
                  );
                }
              },
              isPrefixIcon: false,
              minWidth: double.infinity,
              backgroundColor: whiteColor,
              textColor: primaryBlackColor,
              height: 48,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
