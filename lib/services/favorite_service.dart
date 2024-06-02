import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/song.dart';

class FavoriteService {
  static Future<void> addToFavorites(Song song) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final userId = user.uid;
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(song.id);

      await docRef.set({
        'song_title': song.songTitle,
        'creator': song.creator,
        'genre': song.genre,
        'arangement': song.arangement,
        'image_song': song.imageSong ?? '',
        'description': song.description,
        'price': song.price,
        'isRecommended': song.isRecommended,
        'specialOffer': song.specialOffer ?? '',
        'rating': song.rating,
        'isFavorite': true,
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
      final userId = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .where(FieldPath.documentId, isEqualTo: songId)
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
    final userId = user.uid;

    return FirebaseFirestore.instance
        .collection('users') 
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Song.fromFirestore(doc.data(), doc.id)).toList());
  }
}
