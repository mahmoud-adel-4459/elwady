import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int current = 0;
  static const slides = [
    (
      'onboarding_1.png',
      'لحوم فاخرة تصل إلى بابك',
      'قطع مختارة بعناية من مزارعنا الموثوقة، طازجة ومبرّدة وجاهزة للطهي.'
    ),
    (
      'onboarding_2.jpg',
      'اختر تقطيعك وكمياتك',
      'حدد نوع التقطيع، الوزن، والتجهيز حسب ذوقك — وجهّزه لك تماماً كما تريد.'
    ),
    (
      'onboarding_3.jpg',
      'منتجات متاحة حسب منطقتك',
      'نعرض لك ما هو متوفر فعلًا في منطقتك لنضمن أعلى درجات الطازجة والسرعة.'
    ),
  ];
  @override
  Widget build(BuildContext context) => PopScope(
      canPop: current == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => current--);
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: LayoutBuilder(
        builder: (context, bounds) => SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: bounds.maxHeight),
          child: Column(children: [
            SizedBox(
                height: (bounds.maxHeight * .735).clamp(260.0, 650.0),
                width: double.infinity,
                child: Stack(fit: StackFit.expand, children: [
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset('assets/images/${slides[current].$1}',
                          key: ValueKey(current),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          alignment: current == 0
                              ? const Alignment(0, -.2)
                              : current == 1
                                  ? const Alignment(0, -.3)
                                  : const Alignment(-.1, 0))),
                  const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 180,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x00FFFFFF), Colors.white])))),
                  Positioned(
                      top: 48,
                      left: 20,
                      child: TextButton(
                          onPressed: () => context
                              .read<AppProvider>()
                              .setFlow(AppFlow.login),
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0x66000000),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14)),
                          child: const Text('تخطي',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)))),
                ])),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (i) => GestureDetector(
                              onTap: () => setState(() => current = i),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      width: i == current ? 24 : 6,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: i == current
                                              ? const Color(0xFF741018)
                                              : const Color(0xFFE2DCDA),
                                          borderRadius:
                                              BorderRadius.circular(3))))))),
                  const SizedBox(height: 20),
                  Text(slides[current].$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24,
                          height: 1.28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(slides[current].$3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.65,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF77706D)))),
                  const SizedBox(height: 28),
                  SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                          onPressed: () {
                            if (current < 2) {
                              setState(() => current++);
                            } else {
                              context
                                  .read<AppProvider>()
                                  .setFlow(AppFlow.login);
                            }
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF741018),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16))),
                          child: Text(current == 2 ? 'ابدأ التسوق' : 'التالي',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)))),
                ])),
          ]),
        )),
      ))));
}
