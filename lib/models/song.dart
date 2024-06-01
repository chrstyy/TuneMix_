class Song {
  String id;
  final String songTitle;
  final String creator;
  final String genre;
  final String arangement;
  final String description;
  String? imageSong;
  final double price;
  final bool isRecommended;
  final String? specialOffer;
  bool isFavorite;

  Song({
    required this.id,
    required this.songTitle,
    required this.creator,
    required this.genre,
    required this.description,
    this.imageSong,
    required this.price,
    required this.arangement,
    this.isRecommended = false,
    this.specialOffer,
    required this.isFavorite,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String id) {
    return Song(
      id: id,
      songTitle: data['song_title'] as String,
      creator: data['creator'] as String,
      genre: data['genre'] as String,
      description: data['description'] as String,
      imageSong: data['image_song'] as String?,
      arangement: data['arangement'] as String,
      price: (data['price'] as num).toDouble(),
      isRecommended: data['is_recommended'] as bool? ?? true,
      specialOffer: data['special_offer'] as String?,
      isFavorite: data['isFavorite'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'song_title': songTitle,
      'creator': creator,
      'genre': genre,
      'description': description,
      'image_song': imageSong,
      'price': price,
      'arangement': arangement,
      'is_recommended': isRecommended,
      'special_offer': specialOffer,
      'isFavorite': isFavorite,
    };
  }
}
