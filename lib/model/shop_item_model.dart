
class AvailabilityModel {
  final String startTime;
  final String endTime;
  final int interval;
  final List<TimeSlot> slots;
  final bool isDayOff;

  AvailabilityModel({
    required this.startTime,
    required this.endTime,
    required this.interval,
    required this.slots,
    required this.isDayOff,
  });

  Map<String, dynamic> toMap() => {
    'startTime': startTime,
    'endTime': endTime,
    'interval': interval,
    'slots': slots.map((s) => s).toList(),
    'isDayOff': isDayOff,
  };

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) => AvailabilityModel(
    startTime: map['startTime'],
    endTime: map['endTime'],
    interval: map['interval'],
    isDayOff: map['isDayOff'],
    slots: List<Map<String, dynamic>>.from(map['slots'])
        .map((e) => TimeSlot.fromMap(e))
        .toList(),
  );
}


class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlot({required this.startTime, required this.endTime, required this.isAvailable});

  factory TimeSlot.fromMap(Map<String, dynamic> map) => TimeSlot(
    startTime: map['start_time'],
    endTime: map['end_time'],
    isAvailable: map['isAvailable'],
  );
}