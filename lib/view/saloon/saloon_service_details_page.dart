// ignore_for_file: prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mushiya_beauty/controller/product_details_controller.dart';
import 'package:mushiya_beauty/model/salon_service_firebase_model.dart';
import 'package:mushiya_beauty/utills/app_colors.dart';
import 'package:mushiya_beauty/view/cart/saloon_cart.dart';
import 'package:mushiya_beauty/view/checkout/checkout_page.dart';
import 'package:mushiya_beauty/view/faq/faq_page.dart';
import 'package:mushiya_beauty/widget/custom_appbar.dart';
import 'package:mushiya_beauty/widget/custom_button.dart';
import 'package:mushiya_beauty/widget/custom_tabbar.dart';
import 'package:mushiya_beauty/widget/custom_text.dart';
import 'package:svg_flutter/svg.dart';
import 'package:mushiya_beauty/controller/cart_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var selectedDay = Rxn<DateTime>(); // Nullable DateTime
  var selectedSlot = ''.obs;
  var timeSlots = <String>[].obs;
  var isServiceAvailable = true.obs; // Flag to check if service is bookable

  void initialize(DateTime firstDay, DateTime lastDay) {
    final DateTime today = DateTime.now();
    // Check if service is expired (end_date is before today)
    if (lastDay.isBefore(today)) {
      isServiceAvailable.value = false;
      timeSlots.clear();
      selectedDay.value = null;
      selectedSlot.value = '';
      return;
    }

    // Ensure firstDay is not before today
    firstDay = firstDay.isAfter(today) ? firstDay : today;
    // Ensure lastDay is after or equal to firstDay
    if (firstDay.isAfter(lastDay)) {
      lastDay = firstDay.add(Duration(days: 7)); // Fallback
    }
    selectedDay.value = firstDay; // Initialize to firstDay
    generateTimeSlots(firstDay);
    isServiceAvailable.value = true;
  }

  void generateTimeSlots(DateTime selectedDate) {
    timeSlots.clear();
    final DateTime startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      9,
      0,
    );
    final DateTime endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      17,
      0,
    );

    DateTime currentTime = startTime;
    while (currentTime.isBefore(endTime) ||
        currentTime.isAtSameMomentAs(endTime)) {
      timeSlots.add(DateFormat('hh:mm a').format(currentTime));
      currentTime = currentTime.add(Duration(minutes: 30));
    }
    selectedSlot.value = ''; // Reset slot selection
  }

  bool get isBookNowEnabled =>
      selectedDay.value != null &&
      selectedSlot.value.isNotEmpty &&
      isServiceAvailable.value;
}

class SaloonServiceDetailsPage extends StatelessWidget {
  SaloonServiceDetailsPage({super.key, required this.title, this.homeModel});
  final CartController cartController = Get.put(CartController());
  final String title;
  final SalonService? homeModel;

  final controller = Get.put(ProductDetailsController());
  final calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => FaqPage());
          },
          materialTapTargetSize: MaterialTapTargetSize.padded,
          shape: const CircleBorder(),
          backgroundColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons_svg/message_icon2.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MyAppBarWidget(
            title: title.toUpperCase(),
            titleImage: true,
            actions: true,
            actionsWidget: SvgPicture.asset('assets/icons_svg/share_icon.svg'),
            leadingButton: true,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 320,
                    aspectRatio: 1.0,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    autoPlayInterval: const Duration(seconds: 3),
                    initialPage: 0,
                  ),
                  items:
                      List.generate(
                        homeModel!.images.length,
                        (index) => index,
                      ).map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.network(
                              homeModel!.images.isEmpty
                                  ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                                  : homeModel!.images[i],
                              height: 320,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/extra_images/girl_1.png',
                                    height: 320,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : Center(
                                            child: CircularProgressIndicator(
                                              color: whiteColor,
                                            ),
                                          ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ),

              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: '\$' + homeModel!.price.toString(),
                    fontSize: 18,
                    fontFamily: 'Archivo',
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: '\$' + homeModel!.discount.toString(),
                    fontSize: 14,
                    fontFamily: 'Archivo',
                    color: redColor,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                  Spacer(),
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                    ),
                  ),
                  CustomText(
                    text: homeModel!.rating.toString(),
                    fontSize: 14,
                    fontFamily: 'Archivo',
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              CustomTabWidget(
                children: [
                  Tab(text: 'Description'),
                  Tab(text: 'Refund & cancellation policy'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    tabbarView(homeModel: homeModel!, title: "Description"),
                    refundCancellationPolicy(
                      homeModel: homeModel!,
                      title: "Shipping policy",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabbarView({required SalonService homeModel, required String title}) {
  final CartController cartController = Get.put(CartController());
  final CalendarController controller = Get.put(CalendarController());

  // Validate and adjust dates
  DateTime firstDay = homeModel.startDate.toLocal();
  DateTime lastDay = homeModel.endDate.toLocal();
  final DateTime today = DateTime.now();

  // Initialize controller
  controller.initialize(firstDay, lastDay);

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Html(
          data: homeModel.description,
          shrinkWrap: true,
          style: {
            'p': Style(
              fontSize: FontSize(14),
              fontWeight: FontWeight.w400,
              color: whiteColor.withOpacity(0.8),
            ),
            'strong': Style(
              fontWeight: FontWeight.w600,
              fontSize: FontSize(16),
              fontFamily: "Roboto",
              color: whiteColor,
            ),
            'ul': Style(margin: Margins(left: Margin(0))),
            'table': Style(
              fontSize: FontSize(14),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: whiteColor.withOpacity(0.8),
            ),
            'td': Style(fontFamily: "Roboto"),
            'span': Style(
              fontSize: FontSize(14),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          },
        ),
        Obx(
          () =>
              controller.isServiceAvailable.value
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 12,
                          right: 12,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TableCalendar(
                          rowHeight: 40,
                          firstDay: firstDay.isAfter(today) ? firstDay : today,
                          lastDay: lastDay,
                          focusedDay:
                              controller.selectedDay.value ??
                              (firstDay.isAfter(today) ? firstDay : today),
                          calendarFormat: CalendarFormat.month,
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          selectedDayPredicate:
                              (day) =>
                                  isSameDay(controller.selectedDay.value, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!selectedDay.isBefore(firstDay) &&
                                !selectedDay.isAfter(lastDay)) {
                              controller.selectedDay.value = selectedDay;
                              controller.generateTimeSlots(selectedDay);
                            }
                          },
                          enabledDayPredicate: (day) {
                            return !day.isBefore(today) &&
                                day.isAfter(
                                  firstDay.subtract(const Duration(days: 1)),
                                ) &&
                                day.isBefore(
                                  lastDay.add(const Duration(days: 1)),
                                );
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: primaryBlackColor,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: primaryBlackColor,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            defaultTextStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: primaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            disabledTextStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: primaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.black,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekendStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: primaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            weekdayStyle: TextStyle(
                              fontFamily: "Roboto",
                              color: primaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            dowTextFormatter:
                                (date, locale) => DateFormat(
                                  'EEE',
                                  locale,
                                ).format(date).substring(0, 1),
                          ),
                        ),
                      ),
                      CustomText(
                        text: "SLOT".toUpperCase(),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: Obx(() {
                          final selected = controller.selectedSlot.value;
                          return controller.timeSlots.isEmpty
                              ? CustomText(
                                text:
                                    "Please select a date to view available slots",
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                color: whiteColor,
                                fontWeight: FontWeight.w400,
                              )
                              : GridView.builder(
                                itemCount: controller.timeSlots.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 4.8,
                                    ),
                                itemBuilder: (context, index) {
                                  final slot = controller.timeSlots[index];
                                  final isSelected = selected == slot;

                                  return GestureDetector(
                                    onTap: () {
                                      controller.selectedSlot.value = slot;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.white70,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomText(
                                        text: slot,
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  );
                                },
                              );
                        }),
                      ),
                      Obx(
                        () => CustomButton(
                          text: "Book now".toUpperCase(),
                          onPressed:
                              controller.isBookNowEnabled
                                  ? () {
                                    cartController.addToCart(
                                      CartItem(
                                        id: homeModel.id,
                                        name: homeModel.sName,
                                        image: homeModel.thumbnailImage,
                                        bookedDate:
                                            controller.selectedDay.value!
                                                .toString(),
                                        timeSlot: controller.selectedSlot.value,
                                        price: homeModel.price,
                                        quantity: 1,
                                      ),
                                    );
                                    Get.snackbar(
                                      'Success',
                                      'Item added to cart!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      mainButton: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                primaryBlackColor,
                                              ),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => SaloonCartPage());
                                        },
                                        child: Text(
                                          "View Cart",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  : () {},
                          backgroundColor:
                              controller.isBookNowEnabled
                                  ? whiteColor
                                  : Colors.grey,
                          textColor: primaryBlackColor,
                          fontSize: 14,
                          minWidth: double.infinity,
                          fontWeight: FontWeight.w600,
                          height: 40,
                        ),
                      ),
                    ],
                  )
                  : CustomText(
                    text: "This service is no longer available for booking.",
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: redColor,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              Get.to(() => CheckoutPage());
            },
            child: CustomText(
              text: 'More payment options',
              fontSize: 12,
              fontFamily: 'Archivo',
              color: whiteColor,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}

Widget refundCancellationPolicy({
  required SalonService homeModel,
  required String title,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      CustomText(
        text: title,
        fontSize: 18,
        fontFamily: 'Archivo',
        color: whiteColor,
        fontWeight: FontWeight.w600,
      ),
      CustomText(
        text:
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla. ',
        fontSize: 12,
        fontFamily: 'Roboto',
        color: whiteColor,
        maxLines: 90,
        fontWeight: FontWeight.w400,
      ),
    ],
  );
}
