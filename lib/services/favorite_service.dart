import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/song.dart';

class FavoriteService {
  static Future<void> addToFavorites(Song song) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final id = user.uid;
      final docRef = FirebaseFirestore.instance
          .collection('favorites')
          .doc('${id}_${song.id}');

      await docRef.set({
        'id': id,
        'songTitle': song.songTitle,
        'creator': song.creator,
        'genre': song.genre,
        'arangement': song.arangement,
        'imageSong': song.imageSong,
        'description': song.description,
        'price': song.price,
        'isFavorite': song.isFavorite
      });
      print("Added to favorites successfully.");
    } catch (error) {
      print("Error adding to favorites: $error");
    }
  }

  static Future<void> removeFromFavorites(String songId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final id = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('id', isEqualTo: id)
          .where(FieldPath.documentId, isEqualTo: '${id}_${songId}')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Removed from favorites successfully.");
    } catch (error) {
      print("Error removing from favorites: $error");
    }
  }

  static Stream<List<Song>> getFavoritesForUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final id = user.uid;
    return FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: id)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Song.fromFirestore(doc.data(), doc.id)).toList());
  }
}
