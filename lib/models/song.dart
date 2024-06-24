class Song {
  String id;
  final String songTitle;
  final String creator;
  final String genre;
  final String arangement;
  final String description;
  final int yearMade;
  String? imageSong;
  final double price;
  final bool isRecommended;
  final String? specialOffer;
  double rating;
  bool isFavorite;

  Song({
    required this.id,
    required this.songTitle,
    required this.creator,
    required this.genre,
    required this.description,
    required this.yearMade,
    this.imageSong,
    required this.price,
    required this.arangement,
    this.isRecommended = false,
    this.specialOffer,
    required this.rating,
    required this.isFavorite,
  });

factory Song.fromFirestore(Map<String, dynamic> data, String id) {
  return Song(
    id: id,
    songTitle: data['song_title'] ?? '',
    creator: data['creator'] ?? '',
    genre: data['genre'] ?? '',
    description: data['description'] ?? '',
    yearMade: int.tryParse(data['description']) ?? DateTime.now().year,
    imageSong: data['image_song'] ?? '',
    arangement: data['arangement'] ?? '',
    price: (data['price'] ?? 0.0).toDouble(),
    isRecommended: data['is_recommended'] ?? false,
    specialOffer: data['special_offer'] ?? '',
    rating: (data['rating'] ?? 0.0).toDouble(),
    isFavorite: data['isFavorite'] as bool? ?? true,
  );
}


  Map<String, dynamic> toFirestore() {
    return {
      'song_title': songTitle,
      'creator': creator,
      'genre': genre,
      'description': description,
      'yearMade': yearMade,
      'image_song': imageSong,
      'price': price,
      'arangement': arangement,
      'is_recommended': isRecommended,
      'special_offer': specialOffer,
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }
}
