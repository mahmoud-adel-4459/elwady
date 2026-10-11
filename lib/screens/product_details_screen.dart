import 'package:flutter/services.dart';
import '../widgets/design_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/customization_options.dart';
import '../providers/app_provider.dart';

const List<CuttingOption> kCuttingOptions = [
  CuttingOption(id: 'cubes', name: 'مكعبات خضار وطبخ (قطع صغيرة)', icon: '🍲'),
  CuttingOption(id: 'mandi', name: 'مندي وكبسة (قطع كبيرة بالعظم)', icon: '🍖'),
  CuttingOption(id: 'steaks', name: 'شرائح ستيك رفيعة للتحمير', icon: '🥩'),
  CuttingOption(id: 'minced', name: 'مفروم ناعم (وجهين)', icon: '🔪'),
  CuttingOption(id: 'whole', name: 'كامل بدون تقطيع (مجهز ومعلق)', icon: '🐑'),
];

const List<PackagingOption> kPackagingOptions = [
  PackagingOption(
    id: 'vacuum',
    name: 'أطباق فوم مفرغة من الهواء (Vacuum)',
    desc: 'تحافظ على نضارة وطراوة اللحم حتى 7 أيام في الثلاجة',
  ),
  PackagingOption(
    id: 'bags',
    name: 'أكياس حفظ وتجميد خاصة',
    desc: 'أكياس صحية سميكة مناسبة للتفريز المباشر',
  ),
];

const List<CarcassOption> kHeadOptions = [
  CarcassOption(id: 'charred', name: 'رأس مشلوط ومجهز'),
  CarcassOption(id: 'skinned', name: 'رأس مسلوخ'),
  CarcassOption(id: 'none', name: 'بدون رأس'),
];

const List<CarcassOption> kOffalOptions = [
  CarcassOption(id: 'cleaned', name: 'كراعين وأحشاء منظفة بالكامل'),
  CarcassOption(id: 'none', name: 'بدون أحشاء وكراعين'),
];

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedWeight = 1;
  int quantity = 1;
  int thumb = 0;
  CuttingOption cut = kCuttingOptions.first;
  PackagingOption packaging = kPackagingOptions.first;
  CarcassOption head = kHeadOptions.first;
  CarcassOption offal = kOffalOptions.first;
  final notes = TextEditingController();
  late final List<WeightPreset> weights;
  @override
  void initState() {
    super.initState();
    weights = widget.product.isCarcass
        ? const [
            WeightPreset(
                label: 'ربع ذبيحة', short: 'ربع ذبيحة', multiplier: .25),
            WeightPreset(
                label: 'نصف ذبيحة', short: 'نصف ذبيحة', multiplier: .5),
            WeightPreset(label: 'ذبيحة كاملة', short: 'كاملة', multiplier: 1),
          ]
        : const [
            WeightPreset(label: '500 جم', short: '٥٠٠ جم', multiplier: .5),
            WeightPreset(label: '1 كجم', short: '١ كجم', multiplier: 1),
            WeightPreset(label: '2 كجم', short: '٢ كجم', multiplier: 2),
            WeightPreset(label: '3 كجم', short: '٣ كجم', multiplier: 3),
            WeightPreset(label: '5 كجم', short: '٥ كجم', multiplier: 5),
          ];
    selectedWeight = widget.product.isCarcass ? 2 : 1;
  }

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  double get total =>
      (widget.product.price * weights[selectedWeight].multiplier)
          .roundToDouble() *
      quantity;
  void add() {
    final weight = weights[selectedWeight];
    context.read<AppProvider>().addToCart(CartItem(
        product: widget.product,
        weightLabel: weight.label,
        weightMultiplier: weight.multiplier,
        quantity: quantity,
        cut: cut.name,
        packaging: packaging.name,
        headOption: widget.product.isCarcass ? head.name : null,
        offalOption: widget.product.isCarcass ? offal.name : null,
        notes: notes.text.trim(),
        totalPrice: total));
    Navigator.pop(context);
  }

  Widget section(String title, [String? subtitle]) => Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        if (subtitle != null)
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted)),
      ]));
  Widget optionGrid(List<CarcassOption> options, CarcassOption selected,
          void Function(CarcassOption) onSelect) =>
      Row(
          children: options
              .map((o) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () => setState(() => onSelect(o)),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: selected.id == o.id
                                ? AppColors.deerBlood50
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            side: BorderSide(
                                color: selected.id == o.id
                                    ? AppColors.deerBlood500
                                    : const Color(0xFFE2DCDC)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(o.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected.id == o.id
                                    ? AppColors.deerBlood500
                                    : AppColors.textPrimary)),
                      ))))
              .toList());
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final app = context.watch<AppProvider>();
    final favorite = app.wishlist.contains(product.id);
    final gallery = [
      product.mainImage,
      'assets/images/steak.jpg',
      'assets/images/onboarding_1.png'
    ];
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 56,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  tooltip: 'رجوع',
                                  onPressed: () => Navigator.pop(context),
                                  style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surfaceMuted),
                                  icon: const Icon(Icons.arrow_back, size: 22)),
                              const Expanded(
                                  child: Text('تفاصيل المنتج',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800))),
                              IconButton(
                                  tooltip: 'مشاركة',
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text:
                                            '${product.title} من الوادي للذبائح — ${product.price} ج.م / ${product.unit}'));
                                    if (context.mounted)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'تم نسخ بيانات المنتج بنجاح')));
                                  },
                                  style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surfaceMuted),
                                  icon: const Icon(Icons.share_outlined,
                                      size: 19)),
                              IconButton(
                                  tooltip: 'المفضلة',
                                  onPressed: () =>
                                      app.toggleWishlist(product.id),
                                  style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surfaceMuted),
                                  icon: Icon(
                                      favorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: favorite
                                          ? AppColors.deerBlood500
                                          : AppColors.textPrimary)),
                            ])),
                    const SizedBox(height: 10),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: AspectRatio(
                            aspectRatio: 1.25,
                            child: Stack(fit: StackFit.expand, children: [
                              Image.asset(gallery[thumb], fit: BoxFit.cover),
                              if (product.badge != null)
                                Positioned(
                                    top: 14,
                                    right: 14,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 7),
                                        decoration: BoxDecoration(
                                            color: AppColors.deerBlood500,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(product.badge!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800)))),
                              Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Row(
                                      children: List.generate(
                                          gallery.length,
                                          (i) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: InkWell(
                                                  onTap: () =>
                                                      setState(() => thumb = i),
                                                  child: Container(
                                                      width: 46,
                                                      height: 46,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color: thumb == i
                                                                  ? AppColors
                                                                      .deerBlood500
                                                                  : Colors.white,
                                                              width: 2.5)),
                                                      clipBehavior: Clip.antiAlias,
                                                      child: Image.asset(gallery[i], fit: BoxFit.cover))))))),
                            ]))),
                    const SizedBox(height: 18),
                    Text(product.title,
                        style: const TextStyle(
                            fontSize: 24,
                            height: 1.3,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(product.subtitle,
                        style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF706764))),
                    const SizedBox(height: 14),
                    DesignPanel(
                        color: const Color(0xFFFAF7F5),
                        radius: 16,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                  '${money(product.price)} / ${product.unit}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.deerBlood500))),
                          Flexible(
                              child: Text(
                                  '⭐ ${product.rating} (${ArabicNumbers.convert(product.reviewsCount)} تقييم)',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700))),
                        ])),
                    const SizedBox(height: 14),
                    const DesignPanel(
                        color: AppColors.deerBlood50,
                        radius: 12,
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(children: [
                          Icon(Icons.verified_user_outlined,
                              size: 18, color: AppColors.deerBlood500),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  'ذبح طازج يومياً تحت إشراف أطباء بيطريين معتمدين',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deerBlood700))),
                        ])),
                    section('اختر الوزن والكمية',
                        'اختر حجم القطعية أو وزن الذبيحة المطلوب'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              weights.length > 3 ? 3 : weights.length,
                          mainAxisExtent:
                              82 * MediaQuery.textScalerOf(context).scale(1),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: weights.length,
                      itemBuilder: (_, i) => InkWell(
                          onTap: () => setState(() => selectedWeight = i),
                          child: Container(
                            decoration: BoxDecoration(
                                color: selectedWeight == i
                                    ? AppColors.deerBlood50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: selectedWeight == i
                                        ? AppColors.deerBlood500
                                        : const Color(0xFFE2DCDC),
                                    width: selectedWeight == i ? 2 : 1)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(weights[i].short,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(
                                      money(product.price *
                                          weights[i].multiplier),
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textMuted))
                                ]),
                          )),
                    ),
                    const SizedBox(height: 12),
                    DesignPanel(
                        color: const Color(0xFFFAF7F5),
                        radius: 14,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(children: [
                          const Expanded(
                              child: Text('الكمية المطلوبة:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800))),
                          IconButton(
                              tooltip: 'إنقاص',
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              icon: const Icon(Icons.remove, size: 15)),
                          Text(ArabicNumbers.convert(quantity),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                          IconButton(
                              tooltip: 'زيادة',
                              onPressed: () => setState(() => quantity++),
                              style: IconButton.styleFrom(
                                  backgroundColor: AppColors.deerBlood500,
                                  foregroundColor: Colors.white),
                              icon: const Icon(Icons.add, size: 15)),
                        ])),
                    section('طريقة التقطيع والتجهيز',
                        'يتم التقطيع فوراً بأحدث الأجهزة المعقمة'),
                    for (final c in kCuttingOptions)
                      ChoiceTile(
                          title: c.name,
                          leading: Text(c.icon,
                              style: const TextStyle(fontSize: 18)),
                          selected: cut.id == c.id,
                          onTap: () => setState(() => cut = c)),
                    if (product.isCarcass) ...[
                      section('تجهيز الرأس'),
                      optionGrid(kHeadOptions, head, (v) => head = v),
                      section('الكراعين والأحشاء'),
                      optionGrid(kOffalOptions, offal, (v) => offal = v),
                    ],
                    section('طريقة التغليف والحفظ',
                        'تغليف صحي يحفظ طراوة ونكهة اللحوم'),
                    for (final p in kPackagingOptions)
                      ChoiceTile(
                          title: p.name,
                          subtitle: p.desc,
                          selected: packaging.id == p.id,
                          onTap: () => setState(() => packaging = p)),
                    section('ملاحظات خاصة للقصاب',
                        'أي طلبات إضافية بخصوص التشفية أو فصل العظام'),
                    TextField(
                        controller: notes,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14),
                        decoration: designInput(
                            'مثال: يرجى تقطيع الضلوع منفصلة وتنعيم اللحم المفروم وجهين إضافيين...')),
                  ]))),
      bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, -4))
                ]),
            child: Row(children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'الإجمالي (${ArabicNumbers.convert(quantity)} ${quantity == 1 ? 'قطعة' : 'قطع'})',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    Text(money(total),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deerBlood500)),
                  ]),
              const SizedBox(width: 18),
              Expanded(
                  child:
                      PrimaryButton(label: 'إضافة إلى السلة', onPressed: add))
            ]),
          )),
    );
  }
}
