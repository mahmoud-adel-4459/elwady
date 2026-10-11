import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool logo = false;
  Timer? phaseTimer;
  Timer? finishTimer;
  @override
  void initState() {
    super.initState();
    phaseTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => logo = true);
    });
    finishTimer = Timer(const Duration(milliseconds: 3800), finish);
  }

  void finish() {
    if (mounted) context.read<AppProvider>().setFlow(AppFlow.onboarding);
  }

  @override
  void dispose() {
    phaseTimer?.cancel();
    finishTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: GestureDetector(
        onTap: finish,
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/images/splash_bg_texture.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                Color(0xD97A1620),
                Color(0xE66B0D15),
                Color(0xF53D060B)
              ],
                      stops: [
                0,
                .45,
                1
              ]))),
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x666B0D15), Color(0xB32D0508)]))),
          Center(
              child: AnimatedSlide(
                  offset: logo ? const Offset(.256, -.142) : Offset.zero,
                  duration: const Duration(milliseconds: 1400),
                  child: AnimatedScale(
                      scale: logo ? 2.5 : 1,
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeOutCubic,
                      child: AnimatedRotation(
                          turns: logo ? -24 / 360 : 0,
                          duration: const Duration(milliseconds: 1400),
                          child: AnimatedSlide(
                              offset:
                                  logo ? const Offset(-.04, .06) : Offset.zero,
                              duration: const Duration(milliseconds: 1400),
                              child: SvgPicture.asset(
                                  'assets/images/splash_cleavers.svg',
                                  width: 390,
                                  height: 844)))))),
          Center(
              child: AnimatedOpacity(
                  opacity: logo ? 1 : 0,
                  duration: const Duration(milliseconds: 900),
                  child: AnimatedScale(
                      scale: logo ? 1 : .85,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 270,
                        height: 276,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(56),
                            border: Border.all(
                                color: const Color(0x26FFFFFF), width: 1.5),
                            gradient: const LinearGradient(
                                colors: [Color(0xFF741018), Color(0xFF570C11)]),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x8C000000),
                                  offset: Offset(0, 24),
                                  blurRadius: 60)
                            ]),
                        child: Image.asset(
                            'assets/images/logo_alwadi_transparent_white.png',
                            fit: BoxFit.contain),
                      )))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 44 + MediaQuery.paddingOf(context).bottom,
              child: const Text('لحوم طازجة · ذبح يومي · جودة مضمونة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xB3FFFFFF)))),
        ]),
      ));
}
