class Product {
  final String name;
  final String brand;
  final double price;
  final String imageUrl;

  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
  });
}

const List<Product> products = [
  Product(
    name: 'iPhone 16 Pro',
    brand: 'Apple',
    price: 69999,
    imageUrl:
        'https://images.unsplash.com/photo-1592286927505-9f6b2d5b6b5d?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'Galaxy S25 Ultra',
    brand: 'Samsung',
    price: 84999,
    imageUrl:
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'Pixel 9 Pro',
    brand: 'Google',
    price: 62999,
    imageUrl:
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'Xiaomi 15 Ultra',
    brand: 'Xiaomi',
    price: 57999,
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'OnePlus 13',
    brand: 'OnePlus',
    price: 49999,
    imageUrl:
        'https://images.unsplash.com/photo-1556656793-08538906a9f8?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'Nothing Phone',
    brand: 'Nothing',
    price: 42999,
    imageUrl:
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'ROG Phone 9 Pro',
    brand: 'ASUS',
    price: 59999,
    imageUrl:
        'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?auto=format&fit=crop&w=800&q=80',
  ),
  Product(
    name: 'Xperia 1 VI',
    brand: 'Sony',
    price: 69999,
    imageUrl:
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
  ),
];