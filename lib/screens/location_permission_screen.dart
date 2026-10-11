import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void finish() => context.read<AppProvider>().setFlow(AppFlow.main);
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: [
      Image.asset('assets/images/product_2.jpg', fit: BoxFit.cover),
      const ColoredBox(color: Color(0x52000000)),
      Center(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 290),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ColoredBox(
                        color: const Color(0xF5FAFAFA),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                              child: Column(children: [
                                CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColors.deerBlood50,
                                    child: Icon(Icons.location_on_outlined,
                                        color: AppColors.deerBlood500,
                                        size: 22)),
                                SizedBox(height: 12),
                                Text(
                                    'السماح لـ «الوادي للذبائح» بالوصول إلى موقعك؟',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(height: 6),
                                Text(
                                    'نستخدم موقعك لعرض المنتجات المتاحة في منطقتك وتحديد أقرب فرع للتوصيل.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 1.6,
                                        color: Color(0xFF55504D))),
                              ])),
                          for (final label in [
                            'السماح أثناء استخدام التطبيق',
                            'السماح مرة واحدة',
                            'عدم السماح'
                          ])
                            Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0x2E3C3C43)))),
                                child: TextButton(
                                    onPressed: finish,
                                    style: TextButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF0A7AFF),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13)),
                                    child: Text(label,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: label ==
                                                    'السماح أثناء استخدام التطبيق'
                                                ? FontWeight.w700
                                                : FontWeight.w500)))),
                        ]))),
              ))),
    ]));
  }
}
