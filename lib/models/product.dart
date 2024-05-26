class Product {
  final String id;
  final String brandName;
  final String productName;
  final String description;
  final double price;
  final String imageProduct;

  Product({
    required this.id,
    required this.brandName,
    required this.productName,
    required this.description,
    required this.price,
    required this.imageProduct,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      brandName: data['brand_name'],
      productName: data['product_name'],
      description: data['description'],
      imageProduct: data['image_product'],
      price: data['price'].toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'brand_name': brandName,
      'product_name': productName,
      'description': description,
      'image_product': imageProduct,
      'price': price,
    };
  }
}
