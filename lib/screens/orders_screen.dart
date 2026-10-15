import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../models/cart_item.dart';
import '../models/order_record.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';
import '../widgets/store_widgets.dart';
import 'flow_screens.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool previous = false;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final placed =
        app.orders.where((o) => o.delivered == previous).toList();
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(children: [
            const StoreHeader(),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                    children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 14),
                      child: Text('طلباتي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800))),
                  Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFECE6DF),
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        tab('الطلبات الحالية', false),
                        tab('السابقة', true)
                      ])),
                  const SizedBox(height: 14),
                  for (final order in placed)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: realOrderCard(context, order)),
                  for (int i = 0; i < 3; i++)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: orderCard(context)),
                ])),
          ])));
  }

  String _when(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return 'اليوم، ${ArabicNumbers.convert(h)}:${ArabicNumbers.convert(m)} ${d.hour >= 12 ? 'م' : 'ص'}';
  }

  Widget realOrderCard(BuildContext context, OrderRecord order) {
    final app = context.read<AppProvider>();
    final delivered = order.delivered;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEE8E8))),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('طلب #${ArabicNumbers.convert(order.number)}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            Text(_when(order.createdAt),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted)),
          ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                  color: delivered
                      ? const Color(0xFFE3EFFF)
                      : const Color(0xFFFDECC8),
                  borderRadius: BorderRadius.circular(99)),
              child: Text(delivered ? 'تم التوصيل' : 'جاري التحضير',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: delivered
                          ? const Color(0xFF2F6FD1)
                          : const Color(0xFFC77700)))),
        ]),
        const SizedBox(height: 10),
        if (!delivered)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                step('تم التأكيد', true),
                line(),
                step('جاري التحضير', false),
                line(),
                step('في الطريق', false),
              ])),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: const Color(0xFFF1ECE9),
                borderRadius: BorderRadius.circular(12)),
            child: Text(order.items.map((i) => i.product.title).join('، '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12))),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF3EEEE)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('الإجمالي: ${money(order.summary.total)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700))))),
          if (!delivered)
            Row(children: [
              TextButton(
                  onPressed: () => app.markOrderDelivered(order),
                  child: const Text('تأكيد الاستلام',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textMuted))),
              TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const OrderTrackingScreen())),
                  icon: const Icon(Icons.local_shipping_outlined, size: 13),
                  label:
                      const Text('تتبع الطلب', style: TextStyle(fontSize: 12))),
            ])
          else
            Row(children: [
              TextButton(
                  onPressed: () {
                    app.reorder(order.items);
                    showSnack(context, 'تمت إضافة المنتجات إلى السلة');
                  },
                  child: const Text('إعادة الطلب',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
              TextButton(
                  onPressed: order.rating != null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => RateOrderScreen(order: order))),
                  child: Text(
                      order.rating == null
                          ? 'تقييم'
                          : 'تقييمك ${ArabicNumbers.convert(order.rating!)} ★',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted))),
            ]),
        ]),
      ]),
    );
  }
  Widget tab(String title, bool value) => Expanded(
      child: SizedBox(
          height: 36,
          child: TextButton(
            onPressed: () => setState(() => previous = value),
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor:
                    previous == value ? Colors.white : Colors.transparent,
                foregroundColor: previous == value
                    ? AppColors.deerBlood700
                    : AppColors.textMuted,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(
                        color: previous == value
                            ? AppColors.deerBlood700
                            : Colors.transparent))),
            child: Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        previous == value ? FontWeight.w800 : FontWeight.w600)),
          )));
  Widget orderCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEE8E8))),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('طلب #٥٤١٢',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  Text('اليوم، ٢:٣٠ م',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ]),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                    color: previous
                        ? const Color(0xFFE3EFFF)
                        : const Color(0xFFFDECC8),
                    borderRadius: BorderRadius.circular(99)),
                child: Text(previous ? 'تم التوصيل' : 'جاري التوصيل',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: previous
                            ? const Color(0xFF2F6FD1)
                            : const Color(0xFFC77700)))),
          ]),
          const SizedBox(height: 10),
          if (!previous)
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  step('تم التأكيد', true),
                  line(),
                  step('جاري التحضير', true),
                  line(),
                  step('في الطريق', false),
                ])),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xFFF1ECE9),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Expanded(
                    child: Text('ريب آي بلدي، كفتة الوادي',
                        style: TextStyle(fontSize: 12))),
                ClipOval(
                    child: Image.asset('assets/images/steak.jpg',
                        width: 28, height: 28, fit: BoxFit.cover))
              ])),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3EEEE)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Expanded(
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('الإجمالي: ٧٠٥ ج.م',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700))))),
            if (!previous)
              TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const OrderTrackingScreen())),
                  icon: const Icon(Icons.local_shipping_outlined, size: 13),
                  label:
                      const Text('تتبع الطلب', style: TextStyle(fontSize: 12))),
            if (previous)
              Row(children: [
                TextButton(
                    onPressed: () {
                      final app = context.read<AppProvider>();
                      final p = app.products.firstWhere((p) => p.id == 2);
                      app.reorder([
                        CartItem(
                            product: p,
                            weightLabel: '1 كجم',
                            weightMultiplier: 1,
                            quantity: 1,
                            cut: 'شرائح',
                            packaging: 'تغليف عادي',
                            notes: '',
                            totalPrice: p.price)
                      ]);
                      showSnack(context, 'تمت إضافة المنتجات إلى السلة');
                    },
                    child: const Text('إعادة الطلب',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800))),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => const RateOrderScreen())),
                    child: const Text('تقييم',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted))),
              ]),
          ]),
        ]),
      );
  Widget line() =>
      const Expanded(child: Divider(color: AppColors.deerBlood500));
  Widget step(String label, bool done) => Column(children: [
        CircleAvatar(
            radius: 12,
            backgroundColor:
                done ? AppColors.deerBlood500 : const Color(0xFFECE6E4),
            child: Icon(done ? Icons.check : Icons.local_shipping_outlined,
                size: 14, color: done ? Colors.white : AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ]);
}
