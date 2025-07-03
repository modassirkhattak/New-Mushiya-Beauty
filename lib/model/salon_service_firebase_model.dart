import 'package:cloud_firestore/cloud_firestore.dart';

class SalonService {
  final String id;
  final String sName;
  final String description;
  final String status;
  final String thumbnailImage;
  final List<String> images;
  final double price;
  final double discount;
  final double rating;
  final DateTime startDate;
  final DateTime endDate;

  SalonService({
    required this.id,
    required this.sName,
    required this.description,
    required this.status,
    required this.thumbnailImage,
    required this.images,
    required this.rating,
    required this.price,
    required this.startDate,
    required this.discount,
    required this.endDate,
  });

  factory SalonService.fromMap(Map<String, dynamic> data, String docId) {
    return SalonService(
      id: docId,
      sName: data['s_name'] ?? '',
      description: data['descriptions'] ?? '',
      status: data['status'] ?? '',
      thumbnailImage: data['thumbnnail_image'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
      startDate: (data['start_date'] as Timestamp).toDate(),
      endDate: (data['end_date'] as Timestamp).toDate(),
    );
  }
}
