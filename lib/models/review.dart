import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? id;
  final String title;
  final String description;
  String? imageUrl;
  double? latitude;
  double? longitude;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Review({
    this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['image_url'],
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
