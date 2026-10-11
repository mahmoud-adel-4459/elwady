import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

const kSaudiCities = [
  'الرياض',
  'جدة',
  'مكة المكرمة',
  'المدينة المنورة',
  'الدمام',
  'الخبر',
  'القصيم (بريدة / عنيزة)',
  'الهفوف والأحساء',
  'أبها وخميس مشيط',
  'تبوك',
  'الطائف'
];

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  String city = kSaudiCities.first;
  bool agree = true;
  String? error;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  void submit() {
    if (name.text.trim().length < 3) {
      setState(() => error = 'يرجى إدخال الاسم الكامل (3 أحرف على الأقل)');
      return;
    }
    if (!agree) {
      setState(() => error = 'يرجى الموافقة على الشروط والأحكام للمتابعة');
      return;
    }
    context.read<AppProvider>().completeProfileSetup(
        name: name.text.trim(), email: email.text.trim(), city: city);
  }

  Future<void> chooseCity() async {
    final chosen = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => SizedBox(
            height: MediaQuery.sizeOf(context).height * .65,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(children: [
                  Row(children: [
                    const Expanded(
                        child: Text('اختر المدينة',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800))),
                    IconButton(
                        tooltip: 'إغلاق',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close))
                  ]),
                  Expanded(
                      child: ListView(
                          children: kSaudiCities
                              .map((c) => ChoiceTile(
                                  title: c,
                                  selected: city == c,
                                  onTap: () => Navigator.pop(context, c)))
                              .toList())),
                ]))));
    if (chosen != null && mounted) setState(() => city = chosen);
  }

  Widget label(String value) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
          alignment: Alignment.centerRight,
          child: Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))));
  @override
  Widget build(BuildContext context) => AuthShell(
        header: TextButton(
            onPressed: () =>
                context.read<AppProvider>().setFlow(AppFlow.locationPermission),
            style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceMuted,
                foregroundColor: const Color(0xFF66615E),
                shape: const StadiumBorder()),
            child: const Text('تخطي الآن')),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
              child: Image.asset('assets/images/logo_alwadi_burgundy.png',
                  width: 145)),
          const Text('استكمال البيانات',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
              'مرحباً بك في الوادي للذبائح! نرجو إدخال بياناتك الأساسية لتجهيز وتوصيل طلباتك بأعلى جودة',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, height: 1.6, color: AppColors.textMuted)),
          const SizedBox(height: 28),
          label('الاسم الكامل *'),
          TextField(
              controller: name,
              onChanged: (_) => setState(() => error = null),
              decoration: designInput('مثال: أحمد عبد الله',
                  icon: Icons.person_outline)),
          const SizedBox(height: 16),
          label('المدينة *'),
          InkWell(
              onTap: chooseCity,
              child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFAFAF8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFE2DCDC), width: 1.5)),
                  child: Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: AppColors.deerBlood500),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(city,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700))),
                    const Icon(Icons.expand_more, size: 16)
                  ]))),
          const SizedBox(height: 16),
          label('البريد الإلكتروني (اختياري)'),
          TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              decoration:
                  designInput('name@example.com', icon: Icons.mail_outline)),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                    value: agree,
                    onChanged: (v) => setState(() => agree = v ?? false),
                    activeColor: AppColors.deerBlood500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)))),
            const SizedBox(width: 10),
            const Expanded(
                child: Text(
                    'أوافق على الشروط والأحكام و سياسة الخصوصية لمنصة الوادي للذبائح.',
                    style: TextStyle(
                        fontSize: 12, height: 1.5, color: AppColors.textMuted)))
          ]),
          if (error != null)
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(error!,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.error))),
          const SizedBox(height: 28),
          PrimaryButton(label: 'حفظ ومتابعة', onPressed: submit),
        ]),
      );
}
