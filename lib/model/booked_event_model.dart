import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_model.dart';

class BookedEventModel {
  final String id;
  final String bookedBy;
  final String bookedByName;
  final String bookedByEmail;
  final String bookedTicket;
  final bool booked;
  final EventModel event;
  final Timestamp created_at;

  BookedEventModel({
    required this.id,
    required this.bookedBy,
    required this.bookedByName,
    required this.bookedByEmail,
    required this.bookedTicket,
    required this.booked,
    required this.event,
    required this.created_at,
  });

  factory BookedEventModel.fromSnapshot(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return BookedEventModel(
      id: doc.id,
      bookedBy: json['booked_by'] ?? '',
      bookedByName: json['booked_by_name'] ?? '',
      bookedByEmail: json['booked_by_email'] ?? '',
      bookedTicket: json['booked_ticket'] ?? '',
      created_at: json['created_at'],
      booked: json['booked'] ?? false,
      event: EventModel.fromJson(json['eventAll']),
    );
  }
}
