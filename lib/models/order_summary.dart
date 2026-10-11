import 'delivery_address.dart';

class OrderSummary {
  final double subtotal;
  final double deliveryFee;
  final DateTime date;
  final String slot;
  final DeliveryAddress address;
  const OrderSummary(
      {required this.subtotal,
      required this.deliveryFee,
      required this.date,
      required this.slot,
      required this.address});
  double get total => subtotal + deliveryFee;
}
