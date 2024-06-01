import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song.dart';

class CartService {
  static List<Song> _cartItems = [];

  static void addToCart(Song song) {
    _cartItems.add(song);
  }

  static List<Song> getCartItems() {
    return List.from(_cartItems);
  }

  static void removeFromCart(String songId) {
    _cartItems.removeWhere((song) => song.id == songId);
    FirebaseFirestore.instance.collection('songs').doc(songId).delete();
  }
}