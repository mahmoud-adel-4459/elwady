import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../models/order_summary.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';
import '../widgets/store_widgets.dart';
import 'account_screens.dart';
import 'checkout_screen.dart';

const kDeliverySlots = [
  '٢:٠٠ م',
  '٣:٠٠ م',
  '٤:٠٠ م',
  '٥:٠٠ م',
  '٦:٠٠ م',
  '٧:٠٠ م'
];

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String slot = kDeliverySlots[1];
  DateTime date = DateUtils.dateOnly(DateTime.now());
  final notes = TextEditingController();
  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  Widget title(String text, [IconData? icon]) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.deerBlood500),
          const SizedBox(width: 8)
        ],
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800))),
      ]));
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: Column(children: [
              const StoreHeader(),
              Expanded(
                child: app.cartItems.isEmpty
                    ? const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                      radius: 42,
                                      backgroundColor: AppColors.deerBlood50,
                                      child: Icon(Icons.shopping_bag_outlined,
                                          size: 42,
                                          color: AppColors.deerBlood500)),
                                  SizedBox(height: 20),
                                  Text('سلة المشتريات فارغة',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 10),
                                  Text(
                                      'لم تقم بإضافة أي ذبائح أو قطعيات بعد. تصفح تشكيلة اللحوم الطازجة واختر ما يناسبك.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.6,
                                          color: AppColors.textMuted)),
                                ])))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 140),
                        child: Column(children: [
                          const Text('سلة المشتريات',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(
                              'لديك (${ArabicNumbers.convert(app.cartItems.length)}) منتجات جاهزة للتجهيز والتوصيل',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted)),
                          const SizedBox(height: 24),
                          DesignPanel(
                              child: Row(children: [
                            Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: AppColors.deerBlood50,
                                    borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.location_on_outlined,
                                    size: 22, color: AppColors.deerBlood500)),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  const Text('عنوان التوصيل (المنزل)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textMuted)),
                                  Text(app.deliveryAddress,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800)),
                                  InkWell(
                                      onTap: () {
                                        final next = (app.addresses.indexWhere(
                                                    (a) =>
                                                        a.id ==
                                                        app.currentAddress.id) +
                                                1) %
                                            app.addresses.length;
                                        selectDeliveryAddress(
                                            context, app.addresses[next]);
                                      },
                                      child: const Text('تغيير عنوان التوصيل',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.deerBlood500,
                                              decoration:
                                                  TextDecoration.underline))),
                                ])),
                          ])),
                          const SizedBox(height: 18),
                          title('المنتجات المختارة'),
                          for (int i = 0; i < app.cartItems.length; i++)
                            Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DesignPanel(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.asset(
                                                  app.cartItems[i].product
                                                      .mainImage,
                                                  width: 72,
                                                  height: 72,
                                                  fit: BoxFit.cover)),
                                          const SizedBox(width: 14),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(
                                                    app.cartItems[i].product
                                                        .title,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        height: 1.3,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                const SizedBox(height: 4),
                                                Text(
                                                    '${app.cartItems[i].weightLabel} · ${app.cartItems[i].cut}',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        height: 1.4,
                                                        color: AppColors
                                                            .textMuted)),
                                                const SizedBox(height: 6),
                                                Text(
                                                    money(app.cartItems[i]
                                                        .totalPrice),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: AppColors
                                                            .deerBlood500)),
                                              ])),
                                          const SizedBox(width: 6),
                                          Column(children: [
                                            IconButton(
                                                tooltip: 'حذف المنتج من السلة',
                                                onPressed: () =>
                                                    app.removeFromCart(i),
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 15,
                                                    color: AppColors.error)),
                                            Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _step(
                                                      Icons.remove,
                                                      'إنقاص',
                                                      () => app.updateQuantity(
                                                          i,
                                                          app.cartItems[i]
                                                                  .quantity -
                                                              1)),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4),
                                                      child: Text(
                                                          ArabicNumbers.convert(
                                                              app.cartItems[i]
                                                                  .quantity),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800))),
                                                  _step(
                                                      Icons.add,
                                                      'زيادة',
                                                      () => app.updateQuantity(
                                                          i,
                                                          app.cartItems[i]
                                                                  .quantity +
                                                              1)),
                                                ]),
                                          ]),
                                        ]))),
                          const SizedBox(height: 6),
                          DesignPanel(
                              child: Column(children: [
                            title('ملاحظات التقطيع والتجهيز',
                                Icons.description_outlined),
                            TextField(
                                controller: notes,
                                maxLines: 3,
                                decoration: designInput(
                                    'مثال: يرجى تقطيع الذبيحة أرباع، تغليف كل 2 كجم على حدة، وفصل الشحم...'))
                          ])),
                          const SizedBox(height: 18),
                          DesignPanel(
                              child: Column(children: [
                            title('تاريخ الاستلام والذبح',
                                Icons.calendar_today_outlined),
                            Text(DateFormat('EEEE d MMM', 'ar').format(date),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deerBlood500)),
                            DeliveryCalendar(
                                selected: date,
                                onSelect: (d) => setState(() => date = d)),
                          ])),
                          const SizedBox(height: 18),
                          DesignPanel(
                              child: Column(children: [
                            title('مواعيد التوصيل المتاحة', Icons.access_time),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: kDeliverySlots.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisExtent: 42,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (_, i) => InkWell(
                                  onTap: () =>
                                      setState(() => slot = kDeliverySlots[i]),
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: slot == kDeliverySlots[i]
                                              ? AppColors.deerBlood50
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: slot == kDeliverySlots[i]
                                                  ? AppColors.deerBlood500
                                                  : const Color(0xFFE2DCDC))),
                                      child: Text(kDeliverySlots[i],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: slot == kDeliverySlots[i]
                                                  ? AppColors.deerBlood500
                                                  : AppColors.textPrimary)))),
                            ),
                          ])),
                          const SizedBox(height: 18),
                          DesignPanel(
                              child: Column(children: [
                            title('ملخص الحساب'),
                            bill('المجموع الفرعي للطلب',
                                money(app.cartSubtotal)),
                            bill('رسوم التوصيل والسيارة المبردة',
                                money(app.deliveryFee)),
                            bill('ضريبة القيمة المضافة (شاملة)', 'مشمولة'),
                            const Divider(height: 24),
                            Row(children: [
                              const Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text('الإجمالي النهائي',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800)),
                                    Text('الدفع عند الاستلام أو مدى / فيزا',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted)),
                                  ])),
                              Text(money(app.cartTotal),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.deerBlood500))
                            ]),
                          ])),
                          const SizedBox(height: 18),
                          PrimaryButton(
                              label: 'متابعة الدفع (${money(app.cartTotal)})',
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (_) => CheckoutScreen(
                                          order: OrderSummary(
                                              subtotal: app.cartSubtotal,
                                              deliveryFee: app.deliveryFee,
                                              date: date,
                                              slot: slot,
                                              address: app.currentAddress))))),
                        ])),
              )
            ])));
  }

  Widget _step(IconData icon, String label, VoidCallback tap) => SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
          tooltip: label,
          padding: EdgeInsets.zero,
          onPressed: tap,
          icon: Icon(icon, size: 13)));
}

Widget bill(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Expanded(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textMuted))),
      const SizedBox(width: 8),
      Text(value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
    ]));

class DeliveryCalendar extends StatefulWidget {
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  const DeliveryCalendar(
      {super.key, required this.selected, required this.onSelect});
  @override
  State<DeliveryCalendar> createState() => _DeliveryCalendarState();
}

class _DeliveryCalendarState extends State<DeliveryCalendar> {
  late DateTime month;
  @override
  void initState() {
    super.initState();
    month = DateTime(widget.selected.year, widget.selected.month);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final first = month.weekday % 7;
    final days = DateTime(month.year, month.month + 1, 0).day;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            tooltip: 'الشهر السابق',
            onPressed: () =>
                setState(() => month = DateTime(month.year, month.month - 1)),
            icon: const Icon(Icons.chevron_right, size: 20)),
        Text(DateFormat('MMMM yyyy', 'ar').format(month),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        IconButton(
            tooltip: 'الشهر التالي',
            onPressed: () =>
                setState(() => month = DateTime(month.year, month.month + 1)),
            icon: const Icon(Icons.chevron_left, size: 20)),
      ]),
      Row(children: [
        for (final day in [
          'أحد',
          'إثنين',
          'ثلاثاء',
          'أربعاء',
          'خميس',
          'جمعة',
          'سبت'
        ])
          Expanded(
              child: Text(day,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted)))
      ]),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: first + days,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 36,
            crossAxisSpacing: 3,
            mainAxisSpacing: 6),
        itemBuilder: (_, i) {
          if (i < first) return const SizedBox();
          final value = DateTime(month.year, month.month, i - first + 1);
          final selected = DateUtils.isSameDay(value, widget.selected);
          return InkWell(
              onTap:
                  value.isBefore(today) ? null : () => widget.onSelect(value),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: selected
                          ? AppColors.deerBlood500
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(ArabicNumbers.convert(value.day),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : value.isBefore(today)
                                  ? const Color(0xFFC4BCB8)
                                  : AppColors.textPrimary))));
        },
      ),
    ]);
  }
}
