// class Product {
//   final String id;
//   final String brandName;
//   final String productName;
//   final String description;
//   final double price;
//   final String imageProduct;

//   Product({
//     required this.id,
//     required this.brandName,
//     required this.productName,
//     required this.description,
//     required this.price,
//     required this.imageProduct,
//   });

//   factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
//     return Product(
//       id: documentId,
//       brandName: data['brand_name'],
//       productName: data['product_name'],
//       description: data['description'],
//       imageProduct: data['image_product'],
//       price: data['price'].toDouble(),
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'brand_name': brandName,
//       'product_name': productName,
//       'description': description,
//       'image_product': imageProduct,
//       'price': price,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String title;
  String creator;
  String genre;
  String lyrics;
  String imageUrl;
  DateTime? timestamp;

  Product({
    this.id,
    required this.title,
    required this.creator,
    required this.genre,
    required this.lyrics,
    required this.imageUrl,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creator': creator,
      'genre': genre,
      'lyrics': lyrics,
      'image_url': imageUrl,
      'timestamp': timestamp?.toUtc(),
    };
  }

  static Product fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      title: map['title'],
      creator: map['creator'],
      genre: map['genre'],
      lyrics: map['lyrics'],
      imageUrl: map['image_url'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
