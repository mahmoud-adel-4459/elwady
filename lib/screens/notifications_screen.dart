import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  static const items = [
    (
      Icons.local_shipping_outlined,
      'طلبك في الطريق إليك! 🚚',
      'طلب #TAJ-20250727 في طريقه إليك الآن، سيكون عندك قريباً.',
      'قبل ١٥ دقيقة.'
    ),
    (
      Icons.local_offer_outlined,
      'عرض خاص على اللحوم الطازجة! 🔥',
      'احصل على خصم ٢٥٪ على جميع أنواع اللحوم لمدة ٤٨ ساعة فقط.',
      'قبل ساعة.'
    ),
    (
      Icons.sync,
      'تم تأكيد وزن اللحوم المشتراة! ♻️',
      'تم استلام ٥ كجم من اللحم وإضافتها لرصيدك بقيمة ٧٥ ج.م.',
      'قبل ٣ ساعات.'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                children: [
          ScreenHeading(
              title: 'الإشعارات', onBack: () => Navigator.pop(context)),
          for (final day in ['اليوم', 'أمس']) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(day,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              if (day == 'اليوم')
                TextButton(
                    onPressed: app.markNotificationsRead,
                    child: const Text('تحديد الكل كمقروء',
                        style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline))),
            ]),
            const SizedBox(height: 10),
            for (int i = 0; i < items.length; i++)
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: i == 2 ? () => showWeightNotice(context) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                          color: i < 2 && !app.notificationsRead
                              ? const Color(0xFFFFF7E8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: i < 2 && !app.notificationsRead
                                  ? const Color(0xFFF6DCAA)
                                  : const Color(0xFFE9E3E3))),
                      child: Row(children: [
                        Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: i == 2
                                    ? const Color(0xFFF3DCDF)
                                    : const Color(0xFFFDECC8)),
                            child: Icon(items[i].$1,
                                size: 24,
                                color: i == 2
                                    ? const Color(0xFF9E3A45)
                                    : const Color(0xFFF59A23))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(items[i].$2,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                              Text(items[i].$3,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Color(0xFF55504D))),
                              const SizedBox(height: 4),
                              Text(items[i].$4,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF9A9391))),
                            ])),
                        if (i < 2 && !app.notificationsRead)
                          const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: CircleAvatar(
                                  radius: 4.5,
                                  backgroundColor: Color(0xFFF59A23))),
                      ]),
                    ),
                  )),
            const SizedBox(height: 12),
          ],
        ])));
  }
}

Future<void> showWeightNotice(BuildContext context) => showDialog<void>(
    context: context,
    barrierColor: const Color(0xA6000000),
    builder: (ctx) => Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        tooltip: 'إغلاق',
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 16))),
                const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.deerBlood50,
                    child: Icon(Icons.scale_outlined,
                        size: 30, color: AppColors.deerBlood500)),
                const SizedBox(height: 14),
                const Text('تأكيد وزن اللحوم وتسوية المحفظة ⚖️',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('طلب رقم #ORD-84920 • ملحمة فرع شمال الرياض',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 18),
                const DesignPanel(
                    radius: 12,
                    padding: EdgeInsets.all(14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ريش غنم بلدي طازجة',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w800)),
                          SizedBox(height: 8),
                          Text('الوزن المطلوب للدفع: 2.00 كجم (760 ج.م)',
                              style: TextStyle(fontSize: 12)),
                          Divider(),
                          Text('الوزن الفعلي بعد التشفية: 1.85 كجم (703 ج.م)',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.deerBlood500)),
                          Divider(),
                          Text('الفارق المسترد للعميل: + 57.00 ج.م',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success)),
                        ])),
                const SizedBox(height: 16),
                const DesignPanel(
                    color: AppColors.successBg,
                    radius: 12,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(children: [
                      Icon(Icons.check_circle_outline,
                          color: AppColors.success, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'تم إيداع مبلغ 57.00 ج.م في محفظتك فوراً، ويمكنك استخدامه في طلبك القادم!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success))),
                    ])),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: PrimaryButton(
                          label: 'عرض المحفظة',
                          height: 48,
                          onPressed: () {
                            context.read<AppProvider>().setTab(4);
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          })),
                  const SizedBox(width: 8),
                  Expanded(
                      child: PrimaryButton(
                          label: 'حسناً، فهمت',
                          height: 48,
                          outlined: true,
                          onPressed: () => Navigator.pop(ctx))),
                ]),
              ])),
        ));
