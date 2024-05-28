class Song {
  final String id;
  final String songTitle;
  final String songArtist;
  final String genre;
  final String description;
  final String imageSong;
  final double price;

  Song({
    required this.id,
    required this.songTitle,
    required this.songArtist,
    required this.genre,
    required this.description,
    required this.imageSong,
    required this.price,
  });

  factory Song.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Song(
      id: documentId,
      songTitle: data['song_title'],
      songArtist: data['song_artist'],
      genre: data['genre'],
      description: data['description'],
      imageSong: data['image_song'],
      price: data['price'].toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'song_title': songTitle,
      'song_artist': songArtist,
      'genre': genre,
      'description': description,
      'image_product': imageSong,
      'price': price,
    };
  }
}
