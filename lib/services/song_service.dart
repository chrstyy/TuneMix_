import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:path/path.dart' as path;

class SongService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CollectionReference _songsCollection =
      _database.collection('songs');

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

static Future<void> addSong(Song song, File? image) async {
  try {
    // Upload image to Firebase Storage and get URL
    String imageUrl = '';
    if (image != null) {
      imageUrl = await uploadImage(image);
    }
    
    // Update song's image URL before saving to Firestore
    song.imageSong = imageUrl;

    // Save song to Firestore
    DocumentReference docRef = await _songsCollection.add(song.toFirestore());
    // Get the document ID and update the song object
    song.id = docRef.id;
    
    // Update the document with the correct ID
    await docRef.update({
      'id': docRef.id,
    });
  } catch (e) {
    throw Exception('Error adding song: $e');
  }
}


  Future<void> addToFavorites(String userId, Song song) async {
    try {
      await _database
          .collection('favorites')
          .doc(userId)
          .collection('songs')
          .doc(song.id)
          .set(song.toFirestore());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String userId, String songId) async {
    try {
      await _database
          .collection('favorites')
          .doc(userId)
          .collection('songs')
          .doc(songId)
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<Song>> getFavoriteSongs(String userId) {
    return _database
        .collection('favorites')
        .doc(userId)
        .collection('songs')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Song.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
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

}