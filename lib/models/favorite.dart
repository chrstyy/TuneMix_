import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String songTitle;
  final String creator;
  final String genre;
  final String arrangement;
  final String description;
  final String imageSong;
  final double price;

  Favorite({
    required this.id,
    required this.songTitle,
    required this.creator,
    required this.genre,
    required this.arrangement,
    required this.description,
    required this.imageSong,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songTitle': songTitle,
      'creator': creator,
      'genre': genre,
      'arrangement': arrangement,
      'description': description,
      'imageSong': imageSong,
      'price': price,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id']?? '',
      songTitle: map['songTitle']?? '',
      creator: map['creator']?? '',
      genre: map['genre']?? '',
      arrangement: map['arrangement']?? '',
      description: map['description']?? '',
      imageSong: map['imageSong']?? '',
      price: map['price']?? '',
    );
  }
}
