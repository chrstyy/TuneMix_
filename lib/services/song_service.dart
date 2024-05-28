import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gracieusgalerij/models/song.dart';


class SongService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _songsCollection =
      _database.collection('songs');

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
}
