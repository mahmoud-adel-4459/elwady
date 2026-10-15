import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../models/order_summary.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';
import 'thank_you_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final OrderSummary order;
  const CheckoutScreen({super.key, required this.order});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String method = 'mastercard';
  static const methods = [
    ('mastercard', 'بطاقة مدى / ماستركارد'),
    ('applepay', 'Apple Pay'),
    ('visa', 'فيزا كارد (Visa)'),
    ('cash', 'الدفع نقداً أو شبكة عند الاستلام')
  ];
  Widget row(String label, String value, [IconData? icon]) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.deerBlood500),
          const SizedBox(width: 8)
        ],
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF554D4A)))),
        const SizedBox(width: 8),
        Flexible(
            child: Text(value,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700))),
      ]));
  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenHeading(
                        title: 'إتمام وتأكيد الطلب',
                        fontSize: 24,
                        onBack: () => Navigator.pop(context)),
                    const SizedBox(height: 14),
                    DesignPanel(
                        padding: EdgeInsets.zero,
                        child: Column(children: [
                          row(
                              'التوصيل إلى',
                              'المنزل · ${order.address.address.split('،').first}',
                              Icons.location_on_outlined),
                          const Divider(height: 1),
                          row('طريقة الشحن', 'سيارات مبردة ومعقمة',
                              Icons.local_shipping_outlined),
                          const Divider(height: 1),
                          row('الوقت المقدر', 'خلال الموعد المختار',
                              Icons.access_time),
                        ])),
                    const SizedBox(height: 14),
                    DesignPanel(
                        padding: EdgeInsets.zero,
                        child: Column(children: [
                          row('المجموع الفرعي', money(order.subtotal)),
                          const Divider(height: 1),
                          row('رسوم التوصيل المبرد', money(order.deliveryFee)),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: const BoxDecoration(
                                  color: AppColors.deerBlood50,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(18))),
                              child: Row(children: [
                                const Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text('الإجمالي المستحق',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800)),
                                      Text('شامل ضريبة القيمة المضافة',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted)),
                                    ])),
                                Text(money(order.total),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.deerBlood500))
                              ])),
                        ])),
                    const SizedBox(height: 22),
                    const Text('اختر طريقة الدفع',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    for (final entry in methods)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                              onTap: () => setState(() => method = entry.$1),
                              child: Container(
                                constraints:
                                    const BoxConstraints(minHeight: 54),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: method == entry.$1
                                        ? AppColors.deerBlood50
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: method == entry.$1
                                            ? AppColors.deerBlood500
                                            : AppColors.border,
                                        width: method == entry.$1 ? 1.5 : 1)),
                                child: Row(children: [
                                  Icon(
                                      method == entry.$1
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 20,
                                      color: AppColors.deerBlood500),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(entry.$2,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: method == entry.$1
                                                  ? FontWeight.w800
                                                  : FontWeight.w600))),
                                  const SizedBox(width: 4),
                                  if (entry.$1 == 'mastercard')
                                    const SizedBox(
                                        width: 30,
                                        height: 18,
                                        child: Stack(children: [
                                          Positioned(
                                              right: 0,
                                              child: CircleAvatar(
                                                  radius: 9,
                                                  backgroundColor:
                                                      Color(0xFFEB001B))),
                                          Positioned(
                                              left: 0,
                                              child: CircleAvatar(
                                                  radius: 9,
                                                  backgroundColor:
                                                      Color(0xFFF79E1B)))
                                        ])),
                                  if (entry.$1 == 'applepay')
                                    const Text(' Pay',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                  if (entry.$1 == 'visa')
                                    const Text('VISA',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFF1A1F71))),
                                  if (entry.$1 == 'cash')
                                    const Text('نقدي / شبكة',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.deerBlood500)),
                                ]),
                              ))),
                    const SizedBox(height: 18),
                    const DesignPanel(
                        color: AppColors.successBg,
                        radius: 12,
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(children: [
                          Icon(Icons.verified_user_outlined,
                              size: 20, color: AppColors.success),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  'ضمان الجودة الذهبي: لحوم طازجة ١٠٠٪ وذبح بإشراف بيطري كامل.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success))),
                        ])),
                  ]))),
      bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border))),
              child: PrimaryButton(
                  label: 'تأكيد الطلب الآن · ${money(order.total)}',
                  onPressed: () {
                    context.read<AppProvider>().confirmOrder(order, paymentMethod: method);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => ThankYouScreen(order: order)));
                  }))),
    );
  }
}
