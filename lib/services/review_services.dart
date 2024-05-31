import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gracieusgalerij/models/review.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReviewService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _reviewsCollection =
      _database.collection('reviews');

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(File imageFile) async {
    //klo upload berhasil maka ambil url dri storage, klo idk return null
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');

      UploadTask uploadTask; //upload ke ref yg dituju
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(imageFile);
      }
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addReview(Review reviews) async {
    Map<String, dynamic> newReview = {
      'title': reviews.title,
      'comment': reviews.comment,
      'image_url': reviews.imageUrl,
      'rating': reviews.rating,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _reviewsCollection.add(newReview);
  }

  static Future<void> updateReview(Review reviews) async {
    Map<String, dynamic> updatedReview = {
      'title': reviews.title,
      'comment': reviews.comment,
      'image_url': reviews.imageUrl,
      'rating': reviews.rating,
      'created_at': reviews.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _reviewsCollection.doc(reviews.id).update(updatedReview);
  }

  static Future<void> deleteReview(Review reviews) async {
    await _reviewsCollection.doc(reviews.id).delete();
  }

  static Future<QuerySnapshot> retrieveReviews() {
    return _reviewsCollection.get();
  }

  static Stream<List<Review>> getReviewList() {
    return _reviewsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Review(
          id: doc.id,
          title: data['title'],
          comment: data['comment'],
          imageUrl: data['image_url'],
          rating: data['rating'] ?? 0.0,
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }
}
