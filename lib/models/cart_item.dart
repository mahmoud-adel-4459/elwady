import 'product.dart';

class CartItem {
  final Product product;
  final String weightLabel;
  final double weightMultiplier;
  int quantity;
  final String cut;
  final String packaging;
  final String? headOption;
  final String? offalOption;
  final String notes;
  final double totalPrice;

  CartItem({
    required this.product,
    required this.weightLabel,
    required this.weightMultiplier,
    required this.quantity,
    required this.cut,
    required this.packaging,
    this.headOption,
    this.offalOption,
    required this.notes,
    required this.totalPrice,
  });
}
