import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../models/order_summary.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

class ThankYouScreen extends StatelessWidget {
  final OrderSummary order;
  const ThankYouScreen({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    void finish(int tab) {
      final app = context.read<AppProvider>();
      app.setTab(tab);
      if (tab == 0) {
        app.setCategory('all');
        app.setSearch('');
      }
      Navigator.pop(context);
    }

    return Scaffold(
        body: SafeArea(
            child: LayoutBuilder(
                builder: (_, bounds) => SingleChildScrollView(
                        child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: bounds.maxHeight),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                    radius: 58,
                                    backgroundColor: Color(0xFFF8EEEE),
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: AppColors.deerBlood700,
                                        child: Icon(Icons.check,
                                            size: 42, color: Colors.white))),
                                const SizedBox(height: 28),
                                const Text('شكرًا لطلبك من الوادي!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 10),
                                const Text('تم تأكيد طلبك بنجاح',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deerBlood500)),
                                const SizedBox(height: 8),
                                const Text(
                                    'تقدر تتابع حالة طلبك من صفحة طلباتي.\nسعداء إننا جزء من سفرتك.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        height: 1.9,
                                        color: Color(0xFF88807D))),
                                const SizedBox(height: 28),
                                DesignPanel(
                                    radius: 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 18),
                                    child: Column(children: [
                                      Row(children: [
                                        const Icon(Icons.shopping_bag_outlined,
                                            size: 20,
                                            color: AppColors.deerBlood500),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                            child: Text('إجمالي الطلب',
                                                style:
                                                    TextStyle(fontSize: 14))),
                                        Text(money(order.total),
                                            style: const TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700))
                                      ]),
                                      const Divider(height: 28),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                                Icons.location_on_outlined,
                                                size: 20,
                                                color: AppColors.deerBlood500),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  const Text('عنوان التوصيل',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  const SizedBox(height: 4),
                                                  Text(order.address.address,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          height: 1.8,
                                                          color: Color(
                                                              0xFF88807D)))
                                                ]))
                                          ]),
                                    ])),
                                const SizedBox(height: 30),
                                PrimaryButton(
                                    label: 'متابعة الطلب ←',
                                    height: 52,
                                    onPressed: () => finish(3)),
                                const SizedBox(height: 12),
                                PrimaryButton(
                                    label: 'العودة للرئيسية',
                                    height: 52,
                                    outlined: true,
                                    onPressed: () => finish(0)),
                              ])),
                    )))));
  }
}
