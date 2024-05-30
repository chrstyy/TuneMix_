import 'package:flutter/material.dart';

class Song {
  final String id;
  final String songTitle;
  final String songArtist;
  final String genre;
  final String description;
  final String imageSong;
  final double price;

  Song({
    required this.id,
    required this.songTitle,
    required this.songArtist,
    required this.genre,
    required this.description,
    required this.imageSong,
    required this.price,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Song(
      id: documentId,
      songTitle: data['songTitle'],
      songArtist: data['songArtist'],
      genre: data['genre'],
      description: data['description'],
      imageSong: data['imageSong'],
      price: data['price'].toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'songTitle': songTitle,
      'songArtist': songArtist,
      'genre': genre,
      'description': description,
      'imageSong': imageSong,
      'price': price,
    };
  }
}
