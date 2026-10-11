class Product {
  final int id;
  final String title;
  final String subtitle;
  final String category;
  final String? badge;
  final double price;
  final String unit;
  final double baseWeight;
  final String mainImage;
  final double rating;
  final int reviewsCount;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.badge,
    required this.price,
    required this.unit,
    required this.baseWeight,
    required this.mainImage,
    required this.rating,
    required this.reviewsCount,
    required this.description,
  });

  bool get isCarcass => category == 'carcasses';
}

class CategoryItem {
  final String id;
  final String name;
  final String icon;
  final String? image;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    this.image,
  });
}
