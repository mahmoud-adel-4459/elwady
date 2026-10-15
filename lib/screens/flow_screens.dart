import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../models/delivery_address.dart';
import '../models/order_record.dart';
import '../providers/app_provider.dart';
import '../widgets/design_widgets.dart';

const supportPhone = '+966 800 123 4567';

void showSnack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.deerBlood500,
          content: Text(message,
              style: const TextStyle(
                  fontFamily: 'Cairo', fontWeight: FontWeight.w600))));

/// Confirmation dialog matching the existing "change address" dialog style.
Future<bool> confirmDialog(BuildContext context,
        {required String title,
        required String message,
        required String confirmLabel,
        IconData icon = Icons.warning_amber,
        bool destructive = false}) async =>
    (await showDialog<bool>(
        context: context,
        barrierColor: const Color(0x73000000),
        builder: (ctx) => Dialog(
            insetPadding: const EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(
                      radius: 22,
                      backgroundColor: destructive
                          ? AppColors.deerBlood50
                          : const Color(0xFFFFF4DC),
                      child: Icon(icon,
                          color: destructive
                              ? AppColors.deerBlood500
                              : const Color(0xFFF59A23),
                          size: 22)),
                  const SizedBox(height: 12),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          height: 1.7,
                          color: Color(0xFF55504D))),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(
                        child: PrimaryButton(
                            label: confirmLabel,
                            height: 46,
                            onPressed: () => Navigator.pop(ctx, true))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: PrimaryButton(
                            label: 'إلغاء',
                            height: 46,
                            outlined: true,
                            onPressed: () => Navigator.pop(ctx, false))),
                  ]),
                ]))))) ??
    false;

// ---------------------------------------------------------------------------
// Support / Help center
// ---------------------------------------------------------------------------

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final message = TextEditingController();
  int? open;
  static const faqs = [
    (
      'كم تستغرق مدة التوصيل؟',
      'نوصّل طلبك خلال ساعتين إلى أربع ساعات حسب الموعد الذي تختاره عند إتمام الطلب.'
    ),
    (
      'هل يمكنني تعديل أو إلغاء الطلب؟',
      'يمكنك التواصل معنا قبل بدء التجهيز لتعديل الطلب أو إلغائه دون أي رسوم.'
    ),
    (
      'ما طرق الدفع المتاحة؟',
      'نقبل بطاقات مدى وماستركارد وفيزا، والدفع نقداً أو بالشبكة عند الاستلام.'
    ),
    (
      'كيف أضمن جودة اللحوم؟',
      'جميع الذبائح تُذبح في نفس اليوم تحت إشراف بيطري كامل مع ضمان الجودة الذهبي.'
    ),
  ];

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  void send() {
    if (message.text.trim().isEmpty) {
      showSnack(context, 'يرجى كتابة رسالتك أولاً');
      return;
    }
    FocusScope.of(context).unfocus();
    message.clear();
    showSnack(context, 'تم إرسال رسالتك، سنرد عليك في أقرب وقت');
  }

  Widget contactTile(IconData icon, String title, String sub, Color bg,
          Color fg, VoidCallback onTap) =>
      Expanded(
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: bg, borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundColor: fg,
                        child: Icon(icon, size: 19, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800)),
                    Text(sub,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted)),
                  ]))));

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              children: [
        ScreenHeading(
            title: 'المساعدة والدعم', onBack: () => Navigator.pop(context)),
        Row(children: [
          contactTile(Icons.phone, 'واتساب', 'متاح ٢٤/٧',
              const Color(0xFFD0F4DC), const Color(0xFF26CE50), () {
            Clipboard.setData(const ClipboardData(text: supportPhone));
            showSnack(context, 'تم نسخ رقم الواتس: $supportPhone');
          }),
          const SizedBox(width: 12),
          contactTile(Icons.headset_mic_outlined, 'اتصال', 'خدمة العملاء',
              AppColors.deerBlood50, AppColors.deerBlood500, () {
            Clipboard.setData(const ClipboardData(text: supportPhone));
            showSnack(context, 'تم نسخ رقم خدمة العملاء: $supportPhone');
          }),
        ]),
        const Padding(
            padding: EdgeInsets.only(top: 22, bottom: 10),
            child: Text('الأسئلة الشائعة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
        DesignPanel(
            padding: EdgeInsets.zero,
            radius: 16,
            child: Column(children: [
              for (int i = 0; i < faqs.length; i++) ...[
                InkWell(
                    onTap: () => setState(() => open = open == i ? null : i),
                    child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text(faqs[i].$1,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700))),
                                Icon(
                                    open == i
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: AppColors.textMuted),
                              ]),
                              if (open == i)
                                Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(faqs[i].$2,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            height: 1.7,
                                            color: AppColors.textMuted))),
                            ]))),
                if (i < faqs.length - 1) const Divider(height: 1),
              ]
            ])),
        const Padding(
            padding: EdgeInsets.only(top: 22, bottom: 10),
            child: Text('أرسل لنا رسالة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
        TextField(
            controller: message,
            minLines: 4,
            maxLines: 6,
            decoration: designInput('اكتب استفسارك أو ملاحظتك هنا')),
        const SizedBox(height: 14),
        PrimaryButton(label: 'إرسال', height: 52, onPressed: send),
      ])));
}

// ---------------------------------------------------------------------------
// Payment methods
// ---------------------------------------------------------------------------

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  void addCard(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => const _AddCardSheet());

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                children: [
          ScreenHeading(
              title: 'طرق الدفع', onBack: () => Navigator.pop(context)),
          if (app.cards.isEmpty)
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(children: [
                  CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.deerBlood50,
                      child: Icon(Icons.credit_card,
                          size: 30, color: AppColors.deerBlood500)),
                  SizedBox(height: 12),
                  Text('لا توجد بطاقات محفوظة',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('أضف بطاقة لتسريع إتمام طلباتك القادمة',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ])),
          for (final card in app.cards)
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DesignPanel(
                    radius: 16,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(children: [
                      const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFF3E9EA),
                          child: Icon(Icons.credit_card,
                              size: 18, color: Color(0xFF30272A))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(card.brand,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                            Text(
                                '•••• ${ArabicNumbers.convert(card.last4)}  ${card.holder}',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ])),
                      IconButton(
                          tooltip: 'حذف البطاقة',
                          icon: const Icon(Icons.delete_outline,
                              size: 19, color: AppColors.deerBlood500),
                          onPressed: () async {
                            final ok = await confirmDialog(context,
                                title: 'حذف البطاقة',
                                message:
                                    'هل تريد حذف البطاقة المنتهية بـ ${ArabicNumbers.convert(card.last4)}؟',
                                confirmLabel: 'حذف',
                                destructive: true,
                                icon: Icons.delete_outline);
                            if (ok && context.mounted) app.removeCard(card.id);
                          }),
                    ]))),
          const DesignPanel(
              radius: 16,
              color: AppColors.surfaceMuted,
              child: Row(children: [
                Icon(Icons.payments_outlined,
                    size: 20, color: AppColors.deerBlood500),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                        'الدفع نقداً أو بالشبكة عند الاستلام متاح دائماً.',
                        style: TextStyle(fontSize: 12, height: 1.6))),
              ])),
          const SizedBox(height: 16),
          PrimaryButton(
              label: '+ إضافة بطاقة جديدة',
              height: 52,
              onPressed: () => addCard(context)),
        ])));
  }
}

class _AddCardSheet extends StatefulWidget {
  const _AddCardSheet();
  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final holder = TextEditingController();
  final number = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  String? error;

  @override
  void dispose() {
    holder.dispose();
    number.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  String brandFor(String digits) => digits.startsWith('4')
      ? 'Visa'
      : (digits.startsWith('5') || digits.startsWith('2'))
          ? 'Mastercard'
          : 'مدى';

  void save() {
    final digits = number.text.replaceAll(RegExp(r'\D'), '');
    final exp = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$').firstMatch(expiry.text);
    if (holder.text.trim().isEmpty) {
      return setState(() => error = 'يرجى إدخال اسم حامل البطاقة');
    }
    if (digits.length != 16) {
      return setState(() => error = 'رقم البطاقة يجب أن يتكون من ١٦ رقماً');
    }
    if (exp == null) {
      return setState(() => error = 'تاريخ الانتهاء غير صحيح (MM/YY)');
    }
    if (cvv.text.length < 3) {
      return setState(() => error = 'رمز الأمان غير صحيح');
    }
    final messenger = ScaffoldMessenger.of(context);
    context.read<AppProvider>().addCard(SavedCard(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        brand: brandFor(digits),
        last4: digits.substring(12),
        holder: holder.text.trim()));
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deerBlood500,
        content: Text('تمت إضافة البطاقة بنجاح')));
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(children: [
            Row(children: [
              const Expanded(
                  child: Text('إضافة بطاقة جديدة',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
              IconButton(
                  tooltip: 'إغلاق',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20)),
            ]),
            const SizedBox(height: 8),
            TextField(
                controller: holder,
                decoration: designInput('اسم حامل البطاقة',
                    icon: Icons.person_outline)),
            const SizedBox(height: 10),
            TextField(
                controller: number,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16)
                ],
                decoration:
                    designInput('رقم البطاقة', icon: Icons.credit_card)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: TextField(
                      controller: expiry,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [_ExpiryFormatter()],
                      decoration: designInput('MM/YY'))),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                      controller: cvv,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4)
                      ],
                      decoration: designInput('CVV'))),
            ]),
            if (error != null)
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(error!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.error))),
            const SizedBox(height: 16),
            PrimaryButton(label: 'حفظ البطاقة', height: 52, onPressed: save),
          ])));
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final text = digits.length > 2
        ? '${digits.substring(0, 2)}/${digits.substring(2)}'
        : digits;
    return TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

// ---------------------------------------------------------------------------
// Rate order
// ---------------------------------------------------------------------------

class RateOrderScreen extends StatefulWidget {
  final OrderRecord? order;
  const RateOrderScreen({super.key, this.order});
  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  int stars = 0;
  final comment = TextEditingController();
  final Set<String> tags = {};
  static const options = [
    'جودة اللحم',
    'سرعة التوصيل',
    'التغليف',
    'التقطيع',
    'تعامل المندوب'
  ];

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  String get label => switch (stars) {
        1 => 'سيئ',
        2 => 'مقبول',
        3 => 'جيد',
        4 => 'جيد جداً',
        5 => 'ممتاز',
        _ => 'اضغط على النجوم لتقييم طلبك'
      };

  void submit() {
    final order = widget.order;
    if (order != null) context.read<AppProvider>().rateOrder(order, stars);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deerBlood500,
        content: Text('شكراً لتقييمك! رأيك يهمنا')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              children: [
        ScreenHeading(
            title: 'تقييم الطلب', onBack: () => Navigator.pop(context)),
        const SizedBox(height: 10),
        const Center(
            child: CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.deerBlood50,
                child: Text('🥩', style: TextStyle(fontSize: 34)))),
        const SizedBox(height: 14),
        Text(
            widget.order == null
                ? 'كيف كانت تجربتك؟'
                : 'كيف كان طلب #${ArabicNumbers.convert(widget.order!.number)}؟',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int i = 1; i <= 5; i++)
            IconButton(
                tooltip: '${ArabicNumbers.convert(i)} نجوم',
                onPressed: () => setState(() => stars = i),
                iconSize: 38,
                icon: Icon(i <= stars ? Icons.star : Icons.star_border,
                    color: AppColors.gold)),
        ]),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 20),
        const Text('ما الذي أعجبك؟',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in options)
            ChoiceChip(
                label: Text(t, style: const TextStyle(fontSize: 12)),
                selected: tags.contains(t),
                showCheckmark: false,
                selectedColor: AppColors.deerBlood50,
                backgroundColor: Colors.white,
                side: BorderSide(
                    color: tags.contains(t)
                        ? AppColors.deerBlood500
                        : AppColors.borderSubtle),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tags.contains(t)
                        ? AppColors.deerBlood500
                        : AppColors.textPrimary),
                onSelected: (v) =>
                    setState(() => v ? tags.add(t) : tags.remove(t))),
        ]),
        const SizedBox(height: 18),
        TextField(
            controller: comment,
            minLines: 3,
            maxLines: 5,
            decoration: designInput('أضف تعليقاً (اختياري)')),
        const SizedBox(height: 20),
        PrimaryButton(
            label: 'إرسال التقييم',
            height: 52,
            onPressed: stars == 0 ? null : submit),
      ])));
}

// ---------------------------------------------------------------------------
// Add / edit address
// ---------------------------------------------------------------------------

class AddressFormScreen extends StatefulWidget {
  final DeliveryAddress? existing;
  const AddressFormScreen({super.key, this.existing});
  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  static const types = [
    ('home', 'المنزل', Icons.home_outlined),
    ('work', 'العمل / المكتب', Icons.work_outline),
    ('chalet', 'الاستراحة / المزرعة', Icons.cabin_outlined),
    ('other', 'أخرى', Icons.place_outlined),
  ];
  late String type;
  late final TextEditingController details;
  bool makeDefault = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    type = e == null
        ? 'home'
        : types.any((t) => t.$1 == e.id)
            ? e.id
            : 'other';
    details = TextEditingController(text: e?.address ?? '');
  }

  @override
  void dispose() {
    details.dispose();
    super.dispose();
  }

  void save() {
    if (details.text.trim().length < 5) {
      setState(() => error = 'يرجى كتابة تفاصيل العنوان (الحي والشارع)');
      return;
    }
    final app = context.read<AppProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final label = types.firstWhere((t) => t.$1 == type).$2;
    final e = widget.existing;
    if (e != null) {
      app.updateAddress(DeliveryAddress(
          id: e.id,
          label: label,
          address: details.text.trim(),
          branch: e.branch));
    } else {
      app.addAddress(
          DeliveryAddress(
              id: 'addr_${DateTime.now().microsecondsSinceEpoch}',
              label: label,
              address: details.text.trim(),
              branch: 'فرع وسط الرياض'),
          makeDefault: makeDefault);
    }
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deerBlood500,
        content: Text(e == null ? 'تمت إضافة العنوان' : 'تم تحديث العنوان')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              children: [
        ScreenHeading(
            title: widget.existing == null ? 'تفاصيل العنوان' : 'تعديل العنوان',
            onBack: () => Navigator.pop(context)),
        const Text('نوع العنوان',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        for (final t in types)
          ChoiceTile(
              title: t.$2,
              leading: Icon(t.$3, size: 20, color: AppColors.deerBlood500),
              selected: type == t.$1,
              onTap: () => setState(() => type = t.$1)),
        const SizedBox(height: 12),
        const Text('العنوان بالتفصيل',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        TextField(
            controller: details,
            minLines: 2,
            maxLines: 4,
            onChanged: (_) {
              if (error != null) setState(() => error = null);
            },
            decoration: designInput('الحي، الشارع، رقم المبنى',
                icon: Icons.location_on_outlined)),
        if (error != null)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(error!,
                  style: const TextStyle(fontSize: 12, color: AppColors.error))),
        if (widget.existing == null)
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.deerBlood500,
              title: const Text('تعيين كعنوان افتراضي',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              value: makeDefault,
              onChanged: (v) => setState(() => makeDefault = v)),
        const SizedBox(height: 16),
        PrimaryButton(
            label: widget.existing == null ? 'حفظ العنوان' : 'حفظ التعديلات',
            height: 52,
            onPressed: save),
      ])));
}
