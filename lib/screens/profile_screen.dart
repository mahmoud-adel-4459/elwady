import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../providers/app_provider.dart';
import 'account_screens.dart';
import 'notifications_screen.dart';
import 'flow_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    void openSupport() => Navigator.push(context,
        MaterialPageRoute<void>(builder: (_) => const SupportScreen()));
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
              child: Column(children: [
                Container(
                    constraints: const BoxConstraints(minHeight: 76),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [
                          Color(0xFF760F18),
                          Color(0xFF97101A),
                          Color(0xFFCC1724)
                        ])),
                    child: Row(children: [
                      CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFE64E54),
                          child: Text(
                              app.customerName
                                  .trim()
                                  .split(RegExp(r'\s+'))
                                  .where((s) => s.isNotEmpty)
                                  .take(2)
                                  .map((s) => s[0])
                                  .join(),
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(app.customerName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            Text(app.customerPhone,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xD9FFFFFF))),
                          ])),
                    ])),
                const SizedBox(height: 14),
                _group([
                  _item(
                      Icons.person_outline,
                      'المعلومات الشخصية',
                      'الاسم، البريد الإلكتروني، الهاتف',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const PersonalInfoScreen()))),
                  _item(
                      Icons.location_on_outlined,
                      'العناوين',
                      '${ArabicNumbers.convert(app.addresses.length)} عناوين محفوظة',
                      () => showAddresses(context)),
                  _item(Icons.shopping_basket_outlined, 'طلباتي',
                      'متابعة الطلبات', () => app.setTab(3)),
                  _item(
                      Icons.favorite_border,
                      'قائمة المفضلة',
                      '${ArabicNumbers.convert(app.wishlist.length)} عنصر محفوظ',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const FavoritesScreen()))),
                  _item(Icons.credit_card, 'طرق الدفع', app.cards.isEmpty
                          ? 'لا توجد بطاقات محفوظة'
                          : '${ArabicNumbers.convert(app.cards.length)} بطاقة محفوظة',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const PaymentMethodsScreen())),
                      last: true),
                ]),
                const SizedBox(height: 14),
                _group([
                  _item(
                      Icons.notifications_none,
                      'الإشعارات',
                      'دفع، بريد إلكتروني، رسائل نصية',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const NotificationsScreen()))),
                  _item(
                      Icons.headset_mic_outlined,
                      'المساعدة والدعم',
                      'دردشة ٢٤/٧ معنا',
                      openSupport),
                  _item(Icons.logout, 'تسجيل الخروج', null,
                      () async {
                    final ok = await confirmDialog(context,
                        title: 'تسجيل الخروج',
                        message: 'هل تريد تسجيل الخروج من حسابك؟',
                        confirmLabel: 'تسجيل الخروج',
                        icon: Icons.logout);
                    if (ok) {
                      app.setTab(0);
                      app.setFlow(AppFlow.login);
                    }
                  },
                      last: true),
                ]),
                const SizedBox(height: 14),
                InkWell(
                    onTap: openSupport,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFD0F4DC), Color(0xFFBBEFCE)])),
                    child: Row(children: [
                      const CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xFF26CE50),
                          child:
                              Icon(Icons.phone, size: 19, color: Colors.white)),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('تواصل معنا عبر الواتس',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800)),
                            Text(
                                'تواصل معنا في أي وقت عبر الدردشة المتاحة ٢٤ ساعة',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF6E8173))),
                          ])),
                      const Icon(Icons.chevron_right, size: 16),
                    ]))),
                const SizedBox(height: 16),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Social(network: 'snapchat'),
                      _Social(network: 'facebook'),
                      _Social(network: 'tiktok'),
                    ]),
                const SizedBox(height: 16),
                const Text('رقم السجل التجاري: 123456789\nإصدار التطبيق: 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10, height: 1.9, color: AppColors.textMuted)),
              ]),
            )));
  }

  Widget _group(List<Widget> items) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEE8E8))),
      child: Column(children: items));
  Widget _item(IconData icon, String title, String? sub, VoidCallback onTap,
          {bool last = false}) =>
      InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 65),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                border: last
                    ? null
                    : const Border(
                        bottom: BorderSide(color: Color(0xFFF5F2F2)))),
            child: Row(children: [
              CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFF3E9EA),
                  child: Icon(icon, size: 18, color: const Color(0xFF30272A))),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    if (sub != null)
                      Text(sub,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                  ])),
              const Icon(Icons.chevron_right,
                  size: 16, color: AppColors.textMuted),
            ]),
          ));
}

class _Social extends StatelessWidget {
  final String network;
  const _Social({required this.network});
  @override
  Widget build(BuildContext context) => Column(children: [
        SvgPicture.asset('assets/images/social_$network.svg',
            width: 24, height: 24),
        const SizedBox(height: 4),
        const Text('@El-Wady',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted))
      ]);
}
