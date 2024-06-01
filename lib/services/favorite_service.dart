import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gracieusgalerij/models/favorite.dart';

import '../models/song.dart';

class FavoriteService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _favoriteCollection = _db.collection('favorites');
    static final CollectionReference _songsCollection =
      _db.collection('songs');

  static Future<void> addFavorite(Favorite favorite) async {
    await _favoriteCollection.doc(favorite.id).set(favorite.toMap());
  }

  static Future<void> removeFavorite(String id) async {
    await _favoriteCollection.doc(id).delete();
  }

  static Stream<List<Favorite>> getFavorites() {
    return _favoriteCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Favorite.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  static Future<bool> isFavorite(String songId) async {
    var snapshot = await _favoriteCollection.doc(songId).get();
    return snapshot.exists;
  }

 static Future<Song?> getSongDetail(String songId) async {
    var snapshot = await _songsCollection.doc(songId).get();
    if (snapshot.exists) {
      return Song(
        id: snapshot.id,
        songTitle: snapshot['songTitle'] ?? '',
        creator: snapshot['creator'] ?? '',
        genre: snapshot['genre'] ?? '',
        arangement: snapshot['arrangement'] ?? '',
        description: snapshot['description'] ?? '',
        imageSong: snapshot['imageSong'] ?? '',
        price: snapshot['price'] ?? '',
      );
    } else {
      return null;
    }
  }
}
