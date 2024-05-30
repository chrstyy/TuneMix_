import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  final String songTitle;
  final String creator;
  final String genre;
  final String lyrics;
  final String description;
  String? imageSong;
  final double price;

  Song( {
    required this.id,
    required this.songTitle,
    required this.creator,
    required this.genre,
    required this.description,
    this.imageSong,
    required this.price,
    required this.lyrics,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String id) {
    return Song(
      id: id,
      songTitle: data['song_title'],
      creator: data['creator'],
      genre: data['genre'],
      description: data['description'],
      imageSong: data['image_song'],
      lyrics: data['lyrics'],
      price: data['price'].toDouble(),
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
      'lyrics': lyrics,
    };
  }
}
