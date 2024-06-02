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
  double rating; // tambahkan properti rating
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
    required this.rating, // tambahkan rating ke constructor
    required this.isFavorite,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String id) {
    return Song(
      id: id,
      songTitle: data['song_title'],
      creator: data['creator'],
      genre: data['genre'],
      description: data['description'],
      imageSong: data['image_song'],
      arangement: data['arangement'],
      price: data['price'].toDouble(),
      isRecommended: data['is_recommended'] ?? false,
      specialOffer: data['special_offer'],
      rating: (data['rating'] ?? 0.0).toDouble(), // pastikan untuk mengonversi rating ke double
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
      'rating': rating, // tambahkan rating ke dokumen Firestore
      'isFavorite': isFavorite,
    };
  }
}
