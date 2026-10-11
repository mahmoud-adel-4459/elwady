import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controllers = List.generate(4, (_) => TextEditingController());
  final focuses = List.generate(4, (_) => FocusNode());
  int seconds = 45;
  Timer? timer;
  String? error;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && seconds > 0) setState(() => seconds--);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focuses) {
      f.dispose();
    }
    super.dispose();
  }

  void verify() {
    if (controllers.any((c) => c.text.isEmpty)) {
      setState(() => error = 'يرجى إدخال رمز التحقق كاملاً (4 أرقام)');
      return;
    }
    context.read<AppProvider>().verifyOtpSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<AppProvider>().phoneForOtp;
    return AuthShell(
      header: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.read<AppProvider>().setFlow(AppFlow.login),
          style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted),
          icon: const Icon(Icons.arrow_forward, size: 20)),
      child: Column(children: [
        const Text('أدخل رمز التحقق',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text('أرسلنا رمز تحقق مكوّن من 4 أرقام إلى رقمك',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, height: 1.6, color: AppColors.textMuted)),
        Text(phone.startsWith('+') ? phone : '+966 $phone',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.deerBlood500)),
        const SizedBox(height: 36),
        Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    4,
                    (i) => Padding(
                        padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                        child: SizedBox(
                            width: ((MediaQuery.sizeOf(context).width - 76) / 4)
                                .clamp(40.0, 62.0),
                            height: 64,
                            child: TextField(
                              controller: controllers[i],
                              focusNode: focuses[i],
                              autofocus: i == 0,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1)
                              ],
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF741018)),
                              decoration: designInput('')
                                  .copyWith(contentPadding: EdgeInsets.zero),
                              onChanged: (v) {
                                setState(() => error = null);
                                if (v.isNotEmpty && i < 3)
                                  focuses[i + 1].requestFocus();
                                if (v.isEmpty && i > 0)
                                  focuses[i - 1].requestFocus();
                                if (controllers.every((c) => c.text.isNotEmpty))
                                  verify();
                              },
                            )))))),
        const SizedBox(height: 20),
        if (error != null)
          Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(error!,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.error))),
        if (seconds > 0)
          Text('إعادة إرسال الرمز بعد 00:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted))
        else
          TextButton(
              onPressed: () => setState(() => seconds = 45),
              child: const Text('إعادة إرسال الرمز الآن')),
        const SizedBox(height: 32),
        PrimaryButton(label: 'تأكيد ومتابعة', onPressed: verify),
      ]),
    );
  }
}
