import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../widgets/store_widgets.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool previous = false;
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  for (int i = 0; i < 3; i++)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: orderCard(context)),
                ])),
          ])));
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
                    onPressed: () {},
                    child: const Text('إعادة الطلب',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800))),
                TextButton(
                    onPressed: () {},
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
