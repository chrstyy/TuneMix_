import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as path;

import '../models/song.dart';

class SongService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CollectionReference _songsCollection =
      _database.collection('songs');

  static Future<List<Song>> searchSongs({required String query}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('song_title', isGreaterThanOrEqualTo: query)
        .where('song_title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return querySnapshot.docs
        .map((doc) => Song.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static Future<String> uploadImage(File image) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageRef = _storage.ref().child('song_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

static Future<bool> isFavorite({required String userId, required String songId}) async {
    try {
      DocumentSnapshot docSnapshot = await _database
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(songId)
          .get();
      return docSnapshot.exists;
    } catch (e) {
      throw Exception('Error checking favorite status: $e');
    }
  }

static Future<void> addSong(Song song, File? image) async {
  try {
    String imageUrl = '';
    if (image != null) {
      imageUrl = await uploadImage(image);
    }
    song.imageSong = imageUrl;
    DocumentReference docRef = await _songsCollection.add(song.toFirestore());

    song.id = docRef.id;
    await docRef.update({
      'id': docRef.id,
    });
  } catch (e) {
    throw Exception('Error adding song: $e');
  }
}

  Future<Song> getSongById(String id) async {
    DocumentSnapshot doc = await _database.collection('songs').doc(id).get();
    if (doc.exists) {
      return Song.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      throw Exception('Song not found');
    }
  }

   Future<List<Song>> getAllSongs() async {
    try {
      QuerySnapshot querySnapshot = await _songsCollection.get();
      List<Song> songs = querySnapshot.docs.map((doc) => Song.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
      return songs;
    } catch (e) {
      throw Exception('Error getting songs: $e');
    }
  }

  Future<List<Song>> getSongSpecialOffer({int count = 5}) async {
    try {
      QuerySnapshot collectionSnapshot = await _songsCollection.orderBy(FieldPath.documentId).limit(count).get();
      int totalSongs = collectionSnapshot.docs.length;

      if (totalSongs == 0) return [];

      List<Song> specialOfferSongs = [];
      for (int i = 0; i < totalSongs; i++) {
        DocumentSnapshot docSnapshot = collectionSnapshot.docs[i];
        if (docSnapshot.exists) {
          Song song = Song.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
          specialOfferSongs.add(song);
        }
      }
      return specialOfferSongs;
    } catch (e) {
      throw Exception('Error getting special offer songs: $e');
    }
  }

  Future<List<Song>> getSongRecommend({int count = 5}) async {
    try {
      QuerySnapshot collectionSnapshot = await _songsCollection
          .orderBy('rating', descending: true) 
          .limit(count)
          .get();
      int totalSongs = collectionSnapshot.docs.length;

      if (totalSongs == 0) return [];

      List<Song> recommendedSongs = [];
      for (int i = 0; i < totalSongs; i++) {
        DocumentSnapshot docSnapshot = collectionSnapshot.docs[i];
        if (docSnapshot.exists) {
          Song song = Song.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
          recommendedSongs.add(song);
        }
      }
      return recommendedSongs;
    } catch (e) {
      throw Exception('Error getting recommended songs: $e');
    }
  }


  Future<void> updateSongRating(String songId, double rating) async {
    try {
      await _database.collection('songs').doc(songId).update({
        'rating': rating,
      });
    } catch (e) {
      print('Error updating song rating: $e');
    }
  }
}
