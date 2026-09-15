class Dish {
  final String? id;
  final String name;
  final String description;
  final int price; // en FCFA
  final String imagePath;
  final String category;
  final bool isSpicy;

  const Dish({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    this.isSpicy = false,
  });

  factory Dish.fromFirestore(Map<String, dynamic> data, String id) {
    return Dish(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0) as int,
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? 'Tous',
      isSpicy: data['isSpicy'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'isSpicy': isSpicy,
    };
  }
}
