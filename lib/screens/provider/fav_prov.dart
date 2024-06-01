import 'package:flutter/material.dart';

import '../../models/favorite.dart';
import '../../services/favorite_service.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();

  Stream<List<Favorite>> get favorites => FavoriteService.getFavorites();

  void removeFromFavorites(String favoriteId) {
    FavoriteService.removeFavorite(favoriteId);
  }
}
