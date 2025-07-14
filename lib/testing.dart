// pubspec.yaml dependencies needed:
// get: ^4.6.5
// cloud_firestore: ^4.5.0
// intl: ^0.19.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class AvailabilityModel {
  final String startTime;
  final String endTime;
  final int interval;
  final List<TimeSlot> slots;
  final bool isDayOff;
  final List<String> breakSlots;

  AvailabilityModel({
    required this.startTime,
    required this.endTime,
    required this.interval,
    required this.slots,
    required this.isDayOff,
    required this.breakSlots,
  });

  Map<String, dynamic> toMap() => {
    'startTime': startTime,
    'endTime': endTime,
    'interval': interval,
    'slots': slots.map((s) => s).toList(), // fixed
    'isDayOff': isDayOff,
    'breakSlots': breakSlots,
  };


  factory AvailabilityModel.fromMap(Map<String, dynamic> map) => AvailabilityModel(
    startTime: map['startTime'],
    endTime: map['endTime'],
    interval: map['interval'],
    isDayOff: map['isDayOff'],
    breakSlots: List<String>.from(map['breakSlots'] ?? []),
    slots: List<Map<String, dynamic>>.from(map['slots'] ?? [])
        .map((e) => TimeSlot.fromMap(e))
        .toList(),
  );
}



class CalendarAvailabilityController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString? selectedDate = ''.obs;

  RxList<String> availableDates = <String>[].obs;
  RxList<TimeSlot> slotsForSelectedDate = <TimeSlot>[].obs;

  Future<void> fetchAvailableDates(String doctorId) async {
    print(".......$doctorId");
    final snap = await _firestore.collection('SaloonServices').doc(doctorId).collection('Availability').get();
    availableDates.value = snap.docs.map((doc) => doc.id).toList();
  }

  Future<void> fetchSlotsForDate(String doctorId, String date) async {
    final doc = await _firestore
        .collection('SaloonServices')
        .doc(doctorId)
        .collection('Availability')
        .doc(date)
        .get();

    if (doc.exists && doc.data()?['isDayOff'] == false) {
      final data = doc.data()!;

      final String startTime = data['startTime'];
      final String endTime = data['endTime'];
      final int interval = data['interval'];
      final List<String> breakSlots = List<String>.from(data['breakSlots'] ?? []);
      final List<Map<String, dynamic>>? rawSlots = (data['slots'] as List?)?.cast<Map<String, dynamic>>();

      if (rawSlots != null && rawSlots.isNotEmpty) {
        slotsForSelectedDate.value = rawSlots.map((e) => TimeSlot.fromMap(e)).toList();
      } else {
        // ⚙️ Generate slots manually
        final format = DateFormat('hh:mm a');
        final DateTime start = format.parse(startTime);
        final DateTime end = format.parse(endTime);

        if (start.isAfter(end)) {
          print("❌ startTime is after endTime");
          slotsForSelectedDate.clear();
          return;
        }

        final List<TimeSlot> generatedSlots = [];

        DateTime current = start;
        while (current.isBefore(end)) {
          final DateTime slotEnd = current.add(Duration(minutes: interval));
          final String startStr = format.format(current);
          final String endStr = format.format(slotEnd);
          final bool isAvailable = !breakSlots.contains(startStr);

          generatedSlots.add(TimeSlot(
            startTime: startStr,
            endTime: endStr,
            isAvailable: isAvailable,
          ));

          current = slotEnd;
        }

        slotsForSelectedDate.value = generatedSlots;
      }
    } else {
      print("❌ No data for date $date or marked as day off");
      slotsForSelectedDate.clear();
    }
  }


  DateTime getInitialDate() {
    if (availableDates.isNotEmpty) {
      return DateFormat('dd-MM-yyyy').parse(availableDates.first);
    }
    return DateTime.now(); // fallback
  }

}

class CalendarAvailabilityScreen extends StatefulWidget {
  const CalendarAvailabilityScreen({super.key});

  @override
  State<CalendarAvailabilityScreen> createState() => _CalendarAvailabilityScreenState();
}

class _CalendarAvailabilityScreenState extends State<CalendarAvailabilityScreen> {
  final CalendarAvailabilityController controller = Get.put(CalendarAvailabilityController());

  String? selectedDate;
  final String doctorId = 'doctor123'; // Replace with actual doctor ID

  @override
  void initState() {
    super.initState();
    controller.fetchAvailableDates("F7ng8pVROpLdGiLY70AJ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Select Appointment Date'),actions: [IconButton(onPressed: (){
        Get.to(() => AvailabilityScreen());
      }, icon: Icon(Icons.add))],),
      body: Obx(() {
        return Column(
          children: [
            CalendarDatePicker(
              initialDate: controller.getInitialDate(),
              firstDate: DateTime.now().subtract(const Duration(days: 2)),

              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (date) {
                final formatted = DateFormat('dd-MM-yyyy').format(date);
                if (controller.availableDates.contains(formatted)) {
                  setState(() => selectedDate = formatted);
                  controller.fetchSlotsForDate(doctorId, formatted);
                } else {
                  setState(() => selectedDate = null);
                  controller.slotsForSelectedDate.clear();
                }
              },
              selectableDayPredicate: (date) {
                final formatted = DateFormat('dd-MM-yyyy').format(date);
                return controller.availableDates.contains(formatted);
              },
            ),

            const Divider(),
            if (selectedDate != null)
              Text('Available Slots on $selectedDate', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() {
              if (selectedDate == null) return SizedBox();

              if (controller.slotsForSelectedDate.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No available slots for $selectedDate'),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: controller.slotsForSelectedDate.length,
                  itemBuilder: (_, index) {
                    final slot = controller.slotsForSelectedDate[index];
                    return ListTile(
                      title: Text('${slot.startTime} - ${slot.endTime}'),
                      trailing: Icon(
                        slot.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: slot.isAvailable ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              );
            })


            //
            // Obx(() {
            //   if (controller.slotsForSelectedDate.isEmpty && selectedDate != null) {
            //     return const Text('No available slots or full day off.');
            //   }
            //   return Expanded(
            //     child: ListView.builder(
            //       itemCount: controller.slotsForSelectedDate.length,
            //       itemBuilder: (_, index) {
            //         final slot = controller.slotsForSelectedDate[index];
            //         return ListTile(
            //           title: Text('${slot.startTime} - ${slot.endTime}'),
            //           trailing: Icon(
            //             slot.isAvailable ? Icons.check_circle : Icons.cancel,
            //             color: slot.isAvailable ? Colors.green : Colors.red,
            //           ),
            //         );
            //       },
            //     ),
            //   );
            // }),
          ],
        );
      }),
    );
  }
}
class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      startTime: map['startTime'],
      endTime: map['endTime'],
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSlot &&
              runtimeType == other.runtimeType &&
              startTime == other.startTime &&
              endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  String toString() => "$startTime - $endTime";
}






class AvailabilityController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<TimeSlot> timeSlots = <TimeSlot>[].obs;
  final RxBool isDayOff = false.obs;

  Future<void> generateTimeSlots({
    required String startTimeStr,
    required String endTimeStr,
    required int interval,
    required List<String> breakSlots,
  }) async {
    final format = DateFormat('hh:mm a');
    DateTime startTime = format.parse(startTimeStr);
    DateTime endTime = format.parse(endTimeStr);

    timeSlots.clear();
    while (startTime.isBefore(endTime)) {
      final slotEnd = startTime.add(Duration(minutes: interval));
      final formattedStart = format.format(startTime);
      final formattedEnd = format.format(slotEnd);

      final slot = TimeSlot(
        startTime: formattedStart,
        endTime: formattedEnd,
        isAvailable: !breakSlots.contains(formattedStart),
      );
      timeSlots.add(slot);
      startTime = slotEnd;
    }
  }

  Future<void> saveAvailability({
    required String doctorId,
    required String date,
    required String startTime,
    required String endTime,
    required int interval,
    required List<String> breakSlots,
  }) async {
    final data = AvailabilityModel(
      startTime: startTime,
      endTime: endTime,
      interval: interval,
      slots: timeSlots,
      isDayOff: isDayOff.value,
      breakSlots: breakSlots,
    ).toMap();

    await _firestore
        .collection('SaloonServices')
        .doc(doctorId)
        .collection('Availability')
        .doc(date)
        .set(data);
  }

  Future<void> markDayOff(String doctorId, String date) async {
    await _firestore
        .collection('SaloonServices')
        .doc(doctorId)
        .collection('Availability')
        .doc(date)
        .set({
      'isDayOff': true,
      'slots': [],
      'breakSlots': [],
    });
  }
}


/// --- UI Example ---
class AvailabilityScreen extends StatefulWidget {
  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final AvailabilityController controller = Get.put(AvailabilityController());

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController intervalController = TextEditingController(text: '30');
  final TextEditingController breakSlotController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  List<String> breakSlots = [];

  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.text = DateFormat('hh:mm a').format(dt);
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  void addBreakSlot() {
    if (breakSlotController.text.isNotEmpty) {
      setState(() {
        breakSlots.add(breakSlotController.text);
        breakSlotController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Availability')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Select Date"),
                onTap: () => pickDate(dateController),
              ),
              TextField(
                controller: startTimeController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Start Time"),
                onTap: () => pickTime(startTimeController),
              ),
              TextField(
                controller: endTimeController,
                readOnly: true,
                decoration: InputDecoration(labelText: "End Time"),
                onTap: () => pickTime(endTimeController),
              ),
              TextField(
                controller: intervalController,
                decoration: InputDecoration(labelText: "Interval (minutes)"),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: Text("Mark full day off"),
                value: controller.isDayOff.value,
                onChanged: (val) => controller.isDayOff.value = val,
              ),
              Divider(),
              Text("Break Slots (Optional):"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: breakSlotController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: "Pick Break Time"),
                      onTap: () => pickTime(breakSlotController),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addBreakSlot,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: breakSlots
                    .map((e) => Chip(
                  label: Text(e),
                  onDeleted: () => setState(() => breakSlots.remove(e)),
                ))
                    .toList(),
              ),
              Divider(),
              ElevatedButton(
                onPressed: () => controller.generateTimeSlots(
                  startTimeStr: startTimeController.text,
                  endTimeStr: endTimeController.text,
                  interval: int.tryParse(intervalController.text) ?? 30,
                  breakSlots: breakSlots,
                ),
                child: Text("Generate Slots"),
              ),
              Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.timeSlots.length,
                itemBuilder: (_, index) {
                  final slot = controller.timeSlots[index];
                  return ListTile(
                    title: Text("${slot.startTime} - ${slot.endTime}"),
                    trailing: Icon(
                      slot.isAvailable ? Icons.check : Icons.close,
                      color: slot.isAvailable ? Colors.green : Colors.red,
                    ),
                  );
                },
              )),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.saveAvailability(
                  doctorId: 'F7ng8pVROpLdGiLY70AJ',
                  date: dateController.text,
                  startTime: startTimeController.text,
                  endTime: endTimeController.text,
                  interval: int.tryParse(intervalController.text) ?? 30,
                  breakSlots: breakSlots,
                ),
                child: Text("Save to Firebase"),
              )

            ],
          ),
        ),
      ),
    );
  }
}