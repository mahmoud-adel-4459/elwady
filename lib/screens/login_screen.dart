import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../models/country.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  Country country = kArabCountries.first;
  String? error;
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  void submit() {
    final clean = phone.text
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^0+'), '');
    if (clean.length < 7) {
      setState(() =>
          error = 'يرجى إدخال رقم جوال صحيح (مثال: ${country.placeholder})');
      return;
    }
    context.read<AppProvider>().submitPhoneNumber(clean, country.dial);
  }

  Future<void> chooseCountry() async {
    final chosen = await showModalBottomSheet<Country>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => _CountrySheet(selected: country));
    if (chosen != null && mounted) setState(() => country = chosen);
  }

  @override
  Widget build(BuildContext context) => AuthShell(
        header: TextButton(
            onPressed: () =>
                context.read<AppProvider>().setFlow(AppFlow.locationPermission),
            style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceMuted,
                foregroundColor: const Color(0xFF66615E),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 18)),
            child: const Text('زائر',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 28),
              child: Image.asset('assets/images/logo_alwadi_burgundy.png',
                  width: 150)),
          const Text('تسجيل الدخول',
              style: TextStyle(
                  fontSize: 24, height: 1.3, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('أدخل رقم الجوال للمتابعة واستلام رمز التحقق السريع',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, height: 1.6, color: AppColors.textMuted)),
          const SizedBox(height: 32),
          const Align(
              alignment: Alignment.centerRight,
              child: Text('رقم الجوال',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          Container(
              height: 54,
              decoration: BoxDecoration(
                  color: const Color(0xFFFAFAF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: error != null
                          ? AppColors.error
                          : const Color(0xFFE2DCDC),
                      width: 1.5)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(children: [
                    InkWell(
                        onTap: chooseCountry,
                        child: Row(children: [
                          const Icon(Icons.expand_more, size: 16),
                          const SizedBox(width: 6),
                          Text(country.dial,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 6),
                          SvgPicture.asset(
                              'assets/images/flag_${country.code}.svg',
                              width: 24,
                              height: 16),
                        ])),
                    const SizedBox(width: 8),
                    const SizedBox(
                        height: 24, child: VerticalDivider(width: 1)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => setState(() => error = null),
                            onSubmitted: (_) => submit(),
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                hintText: country.placeholder,
                                border: InputBorder.none,
                                isDense: true))),
                  ]))),
          if (error != null)
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.error))),
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 24),
              child: Text(
                  'بمتابعتك أنت توافق على الشروط والأحكام و سياسة الخصوصية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, height: 1.6, color: AppColors.textMuted))),
          PrimaryButton(label: 'التالي', onPressed: submit),
        ]),
      );
}

String flagFor(String code) =>
    String.fromCharCodes(code.toUpperCase().codeUnits.map((c) => c + 127397));

class _CountrySheet extends StatefulWidget {
  final Country selected;
  const _CountrySheet({required this.selected});
  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final countries = kArabCountries
        .where((c) =>
            c.name.contains(query) ||
            c.dial.contains(query) ||
            c.code.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * .75,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(children: [
              Row(children: [
                const Expanded(
                    child: Text('اختر الدولة',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800))),
                IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18))
              ]),
              TextField(
                  onChanged: (value) => setState(() => query = value),
                  decoration:
                      designInput('ابحث عن الدولة', icon: Icons.search)),
              const SizedBox(height: 16),
              Expanded(
                  child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (_, i) {
                        final c = countries[i];
                        return ChoiceTile(
                            title: c.name,
                            subtitle: c.dial,
                            leading: SvgPicture.asset(
                                'assets/images/flag_${c.code}.svg',
                                width: 28,
                                height: 20),
                            selected: c.code == widget.selected.code,
                            onTap: () => Navigator.pop(context, c));
                      })),
            ])));
  }
}
