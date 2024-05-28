// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/product.dart';

// class ProductService {
//   static final FirebaseFirestore _database = FirebaseFirestore.instance;
//   static final CollectionReference _productsCollection =
//       _database.collection('products');

//   Future<void> addToFavorites(String userId, Product product) async {
//     try {
//       await _database
//           .collection('favorites')
//           .doc(userId)
//           .collection('products')
//           .doc(product.id)
//           .set(product.toFirestore());
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }

//   Future<void> removeFromFavorites(String userId, String productId) async {
//     try {
//       await _database
//           .collection('favorites')
//           .doc(userId)
//           .collection('products')
//           .doc(productId)
//           .delete();
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }

//   Stream<List<Product>> getFavoriteProducts(String userId) {
//     return _database
//         .collection('favorites')
//         .doc(userId)
//         .collection('products')
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => Product.fromFirestore(doc.data(), doc.id))
//               .toList(),
//         );
//   }

//   Future<Product> getProductById(String id) async {
//     DocumentSnapshot doc = await _database.collection('products').doc(id).get();
//     if (doc.exists) {
//       return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
//     } else {
//       throw Exception('Product not found');
//     }
//   }
// }
