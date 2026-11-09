class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.categoryId,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      stock: map['stock'] as int,
      imageUrl: map['image_url'],
      categoryId: map['category_id'] as int?,
    );
  }
}

class ProductFilter {
  final double minPrice;
  final double maxPrice;
  final int pageIndex;

  ProductFilter({this.minPrice = 0, this.maxPrice = 2000, this.pageIndex = 0});

  ProductFilter copyWith({double? minPrice, double? maxPrice, int? pageIndex}) {
    return ProductFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}