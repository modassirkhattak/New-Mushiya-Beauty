import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String locations;
  final String ticket;
  final DateTime dateTime;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.locations,
    required this.ticket,
    required this.dateTime,
  });

  factory EventModel.fromSnapshot(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      locations: json['locations'] ?? '',
      ticket: json['ticket'] ?? '0',
      dateTime: (json['date_time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'locations': locations,
      'ticket': ticket,
      'date_time': Timestamp.fromDate(dateTime),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return EventModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      locations: json['locations'] ?? '',
      ticket: json['ticket'] ?? '0',
      dateTime: (json['date_time'] as Timestamp).toDate(),
    );
  }
}
