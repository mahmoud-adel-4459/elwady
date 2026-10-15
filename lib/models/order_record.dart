import 'cart_item.dart';
import 'order_summary.dart';

class OrderRecord {
  final int number;
  final List<CartItem> items;
  final OrderSummary summary;
  final String paymentMethod;
  final DateTime createdAt;
  bool delivered;
  int? rating;
  OrderRecord(
      {required this.number,
      required this.items,
      required this.summary,
      required this.paymentMethod,
      required this.createdAt,
      this.delivered = false,
      this.rating});
}

class SavedCard {
  final String id;
  final String brand;
  final String last4;
  final String holder;
  const SavedCard(
      {required this.id,
      required this.brand,
      required this.last4,
      required this.holder});
}
