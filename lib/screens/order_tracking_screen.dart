import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../widgets/design_widgets.dart';
import 'cart_screen.dart' show bill;
import 'flow_screens.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});
  static const timeline = [
    ('تم الطلب', '٢٧ يوليو ١٠:٣٠ ص'),
    ('تم التأكيد', '٢٧ يوليو ١٠:٣٠ ص'),
    ('جاري التحضير', 'تجهز منتجاتك بعناية • ٢٧ يوليو ١٠:٣٠ ص'),
    ('المندوب في الطريق', ''),
    ('قريب جداً من موقعك', ''),
    ('تم التوصيل', ''),
    ('تم إكمال الطلب', ''),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenHeading(
                        title: 'تفاصيل الطلب',
                        onBack: () => Navigator.pop(context)),
                    const DesignPanel(
                        radius: 16,
                        padding: EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text('طلب #٥٤١٢',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800))),
                                Text('المندوب في الطريق',
                                    style: TextStyle(
                                        fontSize: 11, color: Color(0xFFC77700)))
                              ]),
                              Text('اليوم، ٢:٣٠ م',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted)),
                              SizedBox(height: 10),
                              Text('ريب آي بلدي، كفتة الوادي',
                                  style: TextStyle(fontSize: 12)),
                              Divider(height: 20),
                              Text('الإجمالي: ٧٠٥ ج.م',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ])),
                    const SizedBox(height: 18),
                    const Text('عنوان التوصيل',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const DesignPanel(
                        radius: 16,
                        padding: EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text('المنزل',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700))),
                                Text('العنوان الأساسي',
                                    style: TextStyle(
                                        fontSize: 11, color: Color(0xFF2F6FD1)))
                              ]),
                              SizedBox(height: 6),
                              Text('حي الياسمين، شارع التخصصي، الرياض',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ])),
                    const SizedBox(height: 20),
                    for (int i = 0; i < timeline.length; i++)
                      SizedBox(
                          height: timeline[i].$2.isEmpty ? 52 : 68,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 22,
                                    child: Column(children: [
                                      Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: i < 3
                                                  ? AppColors.deerBlood700
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: i < 3
                                                      ? AppColors.deerBlood700
                                                      : i == 3
                                                          ? const Color(
                                                              0xFFF59A23)
                                                          : const Color(
                                                              0xFFD9D4D4),
                                                  width: 2)),
                                          child: i < 3
                                              ? const Icon(Icons.check,
                                                  color: Colors.white, size: 12)
                                              : i == 3
                                                  ? const Center(
                                                      child: CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor:
                                                              Color(
                                                                  0xFFF59A23)))
                                                  : null),
                                      if (i < timeline.length - 1)
                                        Expanded(
                                            child: Container(
                                                width: 2,
                                                color: i < 3
                                                    ? AppColors.deerBlood700
                                                    : const Color(0xFFE2DCDC))),
                                    ])),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(timeline[i].$1,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: i < 4
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: i < 4
                                                  ? AppColors.textPrimary
                                                  : const Color(0xFF9A9391))),
                                      if (timeline[i].$2.isNotEmpty)
                                        Text(timeline[i].$2,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textMuted)),
                                    ])),
                              ])),
                    const SizedBox(height: 14),
                    const Text('ملخص الطلب',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    DesignPanel(
                        radius: 16,
                        padding: const EdgeInsets.all(14),
                        child: Column(children: [
                          bill('التوصيل إلى', 'المنزل · حي الياسمين'),
                          bill('طريقة التوصيل', 'توصيل مبرّد سريع'),
                          bill('الوقت المتوقع', 'خلال ٦٠ دقيقة')
                        ])),
                    const SizedBox(height: 10),
                    DesignPanel(
                        radius: 16,
                        padding: const EdgeInsets.all(14),
                        child: Column(children: [
                          bill('المجموع الفرعي', '١٬٠٤٠ ج.م'),
                          bill('رسوم التوصيل', '٢٥ ج.م'),
                          const Divider(height: 20),
                          bill('الإجمالي', '١٬٠٦٥ ج.م')
                        ])),
                  ]))),
      bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: PrimaryButton(
                  label: 'تواصل مع الدعم',
                  height: 52,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const SupportScreen()))))));
}
