// import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       home: CalendarSlotPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class CalendarController extends GetxController {
  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxList<String> timeSlots = <String>[].obs;
  RxString selectedSlot = ''.obs;

  @override
  void onInit() {
    super.onInit();
    generateTimeSlots(); // Initial load
    ever(
      selectedDay,
      (_) => generateTimeSlots(),
    ); // Regenerate slots when date changes
  }

  void generateTimeSlots() {
    final startHour = 10;
    final endHour = 22;
    List<String> slots = [];

    DateTime now = DateTime.now();
    DateTime selected = selectedDay.value;

    DateTime slotTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      startHour,
      0,
    );

    DateTime endTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      endHour,
      0,
    );

    if (isSameDay(now, selected)) {
      // If today, start from the next 30-min rounded time
      if (now.minute < 30) {
        slotTime = DateTime(now.year, now.month, now.day, now.hour, 30);
      } else {
        slotTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
      }
    }

    while (slotTime.isBefore(endTime) || slotTime.isAtSameMomentAs(endTime)) {
      String formattedTime = formatTime(slotTime);
      slots.add(formattedTime);
      slotTime = slotTime.add(Duration(minutes: 30));
    }

    timeSlots.value = slots;
  }

  String formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }
}

// class CalendarSlotPage extends StatelessWidget {
//   final CalendarController controller = Get.put(CalendarController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: greyColor,
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Obx(
//               () => Container(
//                 color: whiteColor,
//                 child: TableCalendar(
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.utc(2030, 12, 31),
//                   focusedDay: controller.selectedDay.value,
//                   calendarFormat: CalendarFormat.month,
//                   startingDayOfWeek: StartingDayOfWeek.sunday,

//                   selectedDayPredicate: (day) {
//                     return isSameDay(controller.selectedDay.value, day);
//                   },

//                   onDaySelected: (selectedDay, focusedDay) {
//                     controller.selectedDay.value = selectedDay;
//                   },
//                   calendarStyle: CalendarStyle(
//                     // defaultDecoration: BoxDecoration(color: whiteColor),
//                     todayDecoration: BoxDecoration(
//                       color: whiteColor,
//                       shape: BoxShape.circle,
//                     ),
//                     selectedDecoration: BoxDecoration(
//                       color: Colors.black,
//                       shape: BoxShape.circle,
//                     ),
//                     selectedTextStyle: TextStyle(color: Colors.white),
//                   ),
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,

//                     titleTextStyle: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     leftChevronIcon: Icon(
//                       Icons.chevron_left,
//                       color: Colors.black,
//                     ),
//                     rightChevronIcon: Icon(
//                       Icons.chevron_right,
//                       color: Colors.black,
//                     ),

//                     decoration: BoxDecoration(
//                       color: whiteColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   daysOfWeekStyle: DaysOfWeekStyle(
//                     weekendStyle: TextStyle(color: Colors.black),
//                     weekdayStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "SLOTS",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Obx(
//               () => Expanded(
//                 child: GridView.builder(
//                   itemCount: controller.timeSlots.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 3.5,
//                   ),
//                   itemBuilder: (context, index) {
//                     final slot = controller.timeSlots[index];
//                     final isSelected = controller.selectedSlot.value == slot;
//                     return GestureDetector(
//                       onTap: () {
//                         controller.selectedSlot.value = slot;
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: isSelected ? Colors.white : Colors.white70,
//                           ),
//                           color: isSelected ? Colors.white : Colors.black,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           slot,
//                           style: TextStyle(
//                             color: isSelected ? Colors.black : Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
