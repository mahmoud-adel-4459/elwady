import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';

String money(num value) => '${ArabicNumbers.convert(value.round())} ج.م';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final double height;
  const PrimaryButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.outlined = false,
      this.height = 54});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.deerBlood500,
                  side: const BorderSide(color: Color(0xFFE9DADD)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)))
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.deerBlood500,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700))));
}

class ScreenHeading extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final double fontSize;
  const ScreenHeading(
      {super.key, required this.title, this.onBack, this.fontSize = 18});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 64,
      child: Stack(alignment: Alignment.center, children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize, fontWeight: FontWeight.w800))),
        if (onBack != null)
          Positioned(
              right: 0,
              child: IconButton(
                  tooltip: 'رجوع',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, size: 22))),
      ]));
}

class DesignPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;
  const DesignPanel(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.color = Colors.white,
      this.radius = 18});
  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000), offset: Offset(0, 2), blurRadius: 8)
          ]),
      child: child);
}

class AuthShell extends StatelessWidget {
  final Widget header;
  final Widget child;
  const AuthShell({super.key, required this.header, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: LayoutBuilder(
        builder: (_, bounds) => SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: bounds.maxHeight),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 32),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: header),
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: child),
                    const SizedBox(height: 10),
                  ])),
        )),
      )));
}

InputDecoration designInput(String hint, {IconData? icon}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
    prefixIcon:
        icon == null ? null : Icon(icon, size: 18, color: AppColors.textMuted),
    filled: true,
    fillColor: const Color(0xFFFAFAF8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2DCDC), width: 1.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppColors.deerBlood500, width: 1.5)));

class ChoiceTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool selected;
  final VoidCallback onTap;
  const ChoiceTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      required this.selected,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: selected ? AppColors.deerBlood50 : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: selected
                        ? AppColors.deerBlood500
                        : const Color(0xFFE2DCDC),
                    width: selected ? 1.5 : 1)),
            child: Row(children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
                            color: selected
                                ? AppColors.deerBlood500
                                : AppColors.textPrimary)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                  ])),
              if (selected)
                const CircleAvatar(
                    radius: 11,
                    backgroundColor: AppColors.deerBlood500,
                    child: Icon(Icons.check, size: 14, color: Colors.white)),
            ]),
          )));
}
