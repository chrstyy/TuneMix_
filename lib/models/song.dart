import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  final String songTitle;
  final String creator;
  final String genre;
  final String arangement;
  final String description;
  String? imageSong;
  final double price;
  final bool isRecommended; // Add this field
  final String? specialOffer; // Add this field

  Song({
    required this.id,
    required this.songTitle,
    required this.creator,
    required this.genre,
    required this.description,
    this.imageSong,
    required this.price,
    required this.arangement,
    this.isRecommended = false, // Initialize with a default value
    this.specialOffer, // Initialize with null by default
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String id) {
    return Song(
      id: id,
      songTitle: data['song_title'],
      creator: data['creator'],
      genre: data['genre'],
      description: data['description'],
      imageSong: data['image_song'],
      arangement: data['arangement'],
      price: data['price'].toDouble(),
      isRecommended: false, // Explicitly set to false
      specialOffer: data['special_offer'], // Add this field
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'song_title': songTitle,
      'creator': creator,
      'genre': genre,
      'description': description,
      'image_song': imageSong,
      'price': price,
      'arangement': arangement,
      'is_recommended': isRecommended, // Add this field
      'special_offer': specialOffer, // Add this field
    };
  }
}