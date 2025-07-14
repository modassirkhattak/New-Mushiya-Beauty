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
import '../../testing.dart';

class CalendarController extends GetxController {
  var selectedDay = Rxn<DateTime>();
  Rx<TimeSlot?> selectedSlot1 = Rx<TimeSlot?>(null);
  var isServiceAvailable = true.obs;

  void initialize(DateTime firstDay, DateTime lastDay, List<String> availableDates) {
    final DateTime today = DateTime.now();
    if (lastDay.isBefore(today)) {
      isServiceAvailable.value = false;
      selectedDay.value = null;
      selectedSlot1.value = null;
      return;
    }
    firstDay = firstDay.isAfter(today) ? firstDay : today;
    if (firstDay.isAfter(lastDay)) {
      lastDay = firstDay.add(Duration(days: 7));
    }
    // Set selectedDay to the first available date, if any
    if (availableDates.isNotEmpty) {
      selectedDay.value = DateFormat('dd-MM-yyyy').parse(availableDates.first);
    } else {
      selectedDay.value = firstDay;
    }
    isServiceAvailable.value = true;
  }

  void selectSlot(TimeSlot slot) {
    selectedSlot1.value = slot;
  }

  bool get isBookNowEnabled =>
      selectedDay.value != null &&
          selectedSlot1.value != null &&
          isServiceAvailable.value;
}

class SaloonServiceDetailsPage extends StatefulWidget {
  SaloonServiceDetailsPage({super.key, required this.title, this.homeModel});
  final String title;
  final SalonService? homeModel;

  @override
  State<SaloonServiceDetailsPage> createState() => _SaloonServiceDetailsPageState();
}

class _SaloonServiceDetailsPageState extends State<SaloonServiceDetailsPage> {
  final CartSaloonController cartController = Get.put(CartSaloonController());
  final controller = Get.put(ProductDetailsController());
  final calendarController = Get.put(CalendarController());
  final CalendarAvailabilityController controllerAvailability = Get.put(CalendarAvailabilityController());

  @override
  void initState() {
    super.initState();
    // Fetch available dates and initialize calendar after data is loaded
    controllerAvailability.fetchAvailableDates(widget.homeModel!.id).then((_) {
      DateTime firstDay = widget.homeModel!.startDate.toLocal();
      DateTime lastDay = widget.homeModel!.endDate.toLocal();
      calendarController.initialize(firstDay, lastDay, controllerAvailability.availableDates);
      // Fetch slots for the initial selected date, if available
      if (controllerAvailability.availableDates.isNotEmpty) {
        final initialDate = controllerAvailability.availableDates.first;
        controllerAvailability.selectedDate!.value = initialDate;
        controllerAvailability.fetchSlotsForDate(widget.homeModel!.id, initialDate);
      }
    });
  }

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
            title: widget.title.toUpperCase(),
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
                  items: List.generate(
                    widget.homeModel!.images.length,
                        (index) => index,
                  ).map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.network(
                          widget.homeModel!.images.isEmpty
                              ? 'https://cdn.shopify.com/s/files/1/1190/6424/files/Afro_Fusion.png?v=1733257065'
                              : widget.homeModel!.images[i],
                          height: 320,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/extra_images/girl_1.png',
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          loadingBuilder: (context, child, loadingProgress) =>
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
              SizedBox(height: 12),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: '\$${widget.homeModel!.price}',
                    fontSize: 18,
                    fontFamily: 'Archivo',
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: '\$${widget.homeModel!.discount}',
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
                          (index) => Icon(Icons.star, color: Colors.yellow, size: 16),
                    ),
                  ),
                  CustomText(
                    text: widget.homeModel!.rating.toString(),
                    fontSize: 14,
                    fontFamily: 'Archivo',
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(height: 12),
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
                    tabbarView(homeModel: widget.homeModel!, title: "Description"),
                    refundCancellationPolicy(
                      homeModel: widget.homeModel!,
                      title: "Refund & cancellation policy",
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

  Widget tabbarView({required SalonService homeModel, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 12),
        Obx(() => calendarController.isServiceAvailable.value
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() {
                return TableCalendar(
                  rowHeight: 40,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: calendarController.selectedDay.value ?? DateTime.now(),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  selectedDayPredicate: (day) {
                    final selected = calendarController.selectedDay.value;
                    return isSameDay(selected, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    final formatted = DateFormat('dd-MM-yyyy').format(selectedDay);
                    if (controllerAvailability.availableDates.contains(formatted)) {
                      calendarController.selectedDay.value = selectedDay;
                      controllerAvailability.selectedDate!.value = formatted;
                      controllerAvailability.fetchSlotsForDate(homeModel.id, formatted);
                    } else {
                      calendarController.selectedDay.value = null;
                      controllerAvailability.selectedDate!.value = '';
                      controllerAvailability.slotsForSelectedDate.clear();
                    }
                  },
                  enabledDayPredicate: (day) {
                    final formatted = DateFormat('dd-MM-yyyy').format(day);
                    return controllerAvailability.availableDates.contains(formatted);
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    defaultTextStyle: const TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    disabledTextStyle: const TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
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
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: const TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    weekdayStyle: const TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    dowTextFormatter: (date, locale) => DateFormat('EEE', locale).format(date)[0],
                  ),
                );
              }),
            ),
            SizedBox(height: 12),
            CustomText(
              text: "SLOTS".toUpperCase(),
              fontSize: 16,
              fontFamily: 'Roboto',
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 270),
              child: Obx(() {
                if (controllerAvailability.selectedDate == null || controllerAvailability.selectedDate!.value.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Please select a date to view available slots',
                      style: TextStyle(color: whiteColor),
                    ),
                  );
                }

                if (controllerAvailability.slotsForSelectedDate.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No available slots for ${controllerAvailability.selectedDate}',
                      style: TextStyle(color: whiteColor),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: controllerAvailability.slotsForSelectedDate.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 4.8,
                  ),
                  itemBuilder: (context, index) {
                    final slot = controllerAvailability.slotsForSelectedDate[index];
                    final isSelected = calendarController.selectedSlot1.value == slot;

                    return GestureDetector(
                      onTap: slot.isAvailable
                          ? () {
                        calendarController.selectSlot(slot);
                        print("Selected: ${slot.startTime} - ${slot.endTime}");
                        setState(() {

                        });
                      }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: slot.isAvailable ==false
                              ?greyColor:isSelected ? Colors.white : Colors.black,
                          border: Border.all(
                            color: slot.isAvailable ==false
                                ?greyColor:isSelected ? Colors.black : Colors.white70,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${slot.startTime} - ${slot.endTime}",
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 12),
            Obx(
                  () => CustomButton(
                text: "Book now".toUpperCase(),
                onPressed: calendarController.isBookNowEnabled
                    ? () {
                  cartController.addToCart(
                    CartItem(
                      id: homeModel.id,
                      name: homeModel.sName,
                      image: homeModel.thumbnailImage,
                      bookedDate: calendarController.selectedDay.value!.toString(),
                      timeSlot: calendarController.selectedSlot1.value.toString(),
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
                        backgroundColor: MaterialStatePropertyAll(primaryBlackColor),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                backgroundColor: calendarController.isBookNowEnabled ? whiteColor : Colors.grey,
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
        )),
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
    );
  }

  Widget refundCancellationPolicy({
    required SalonService homeModel,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 18,
          fontFamily: 'Archivo',
          color: whiteColor,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12),
        CustomText(
          text:
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla.',
          fontSize: 12,
          fontFamily: 'Roboto',
          color: whiteColor,
          maxLines: 90,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}