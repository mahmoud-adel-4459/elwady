import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../models/product.dart';
import '../providers/app_provider.dart';
import '../screens/product_details_screen.dart';
import '../screens/account_screens.dart';
import '../screens/notifications_screen.dart';

const categoryCards = [
  CategoryItem(
      id: 'fresh_cuts',
      name: 'اللحوم الطازجة',
      icon: '🥩',
      image: 'assets/images/steak.jpg'),
  CategoryItem(
      id: 'extras',
      name: 'المنتجات الإضافية',
      icon: '',
      image: 'assets/images/product_3.jpg'),
  CategoryItem(
      id: 'offers', name: 'العروض', icon: '', image: 'assets/images/steak.jpg'),
  CategoryItem(
      id: 'butchery_prep',
      name: 'التقطيع والتجهيز',
      icon: '',
      image: 'assets/images/product_1.jpg'),
  CategoryItem(
      id: 'carcasses',
      name: 'الذبائح',
      icon: '',
      image: 'assets/images/steak.jpg'),
];

Alignment categoryImageAlignment(String id) => switch (id) {
      'fresh_cuts' => const Alignment(0, -.2),
      'offers' => const Alignment(0, .4),
      'carcasses' => const Alignment(0, -.6),
      'extras' => Alignment.centerLeft,
      _ => Alignment.center,
    };

class StoreHeader extends StatelessWidget {
  const StoreHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(children: [
          InkWell(
              onTap: () => app.setTab(4),
              borderRadius: BorderRadius.circular(26),
              child: const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFE5534F),
                  child: Text('🧑🏻‍🦱', style: TextStyle(fontSize: 32)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('مساء الخير، ${app.customerName.split(' ').first}👋',
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF7A7573))),
                InkWell(
                    onTap: () {
                      final next = (app.addresses.indexWhere(
                                  (a) => a.id == app.currentAddress.id) +
                              1) %
                          app.addresses.length;
                      selectDeliveryAddress(context, app.addresses[next]);
                    },
                    child: Row(children: [
                      SvgPicture.asset('assets/images/header_MapPin.svg',
                          width: 20, height: 20),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(
                              app.deliveryAddress.split('،').take(2).join('،'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500))),
                    ])),
              ])),
          const SizedBox(width: 12),
          IconButton(
              tooltip: 'الإشعارات',
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const NotificationsScreen())),
              icon: Badge(
                  isLabelVisible: app.unreadNotifications > 0,
                  label: Text('${app.unreadNotifications}'),
                  backgroundColor: const Color(0xFFE84A4A),
                  child: SvgPicture.asset('assets/images/header_Bell.svg',
                      width: 28, height: 28)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 44)),
          const SizedBox(width: 14),
          IconButton(
              tooltip: 'السلة',
              onPressed: () => app.setTab(2),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 44),
              icon: Badge(
                  isLabelVisible: app.cartItems.isNotEmpty,
                  label: Text('${app.cartItems.length}'),
                  backgroundColor: AppColors.deerBlood500,
                  child: SvgPicture.asset(
                      'assets/images/header_ShoppingCart.svg',
                      width: 28,
                      height: 28))),
        ]));
  }
}

class StoreSearch extends StatefulWidget {
  final bool compact;
  const StoreSearch({super.key, this.compact = false});
  @override
  State<StoreSearch> createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: context.read<AppProvider>().searchQuery);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = context.watch<AppProvider>().searchQuery;
    if (query != controller.text)
      controller.value = TextEditingValue(
          text: query,
          selection: TextSelection.collapsed(offset: query.length));
    final compact = widget.compact;
    return SizedBox(
        height: compact ? 44 : 48,
        child: TextField(
          controller: controller,
          onChanged: context.read<AppProvider>().setSearch,
          style: TextStyle(fontSize: compact ? 13 : 14),
          decoration: InputDecoration(
            hintText: 'ابحث عن لحوم، ذبائح، أو تقطيع…',
            hintStyle: TextStyle(
                fontSize: compact ? 13 : 14, color: AppColors.textMuted),
            prefixIcon: const Icon(Icons.search,
                size: 20, color: AppColors.textSecondary),
            suffixIcon: compact
                ? const Icon(Icons.tune, size: 18, color: AppColors.textMuted)
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(compact ? 14 : 24),
                borderSide: const BorderSide(color: Color(0xFFEEE8E8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(compact ? 14 : 24),
                borderSide: const BorderSide(color: AppColors.deerBlood500)),
          ),
        ));
  }
}

class StoreProductCard extends StatelessWidget {
  final Product product;
  final bool compact;
  final bool showHeart;
  const StoreProductCard(
      {super.key,
      required this.product,
      this.compact = false,
      this.showHeart = false});
  @override
  Widget build(BuildContext context) {
    void open() => Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => ProductDetailsScreen(product: product)));
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compact ? 18 : 20),
          side: const BorderSide(color: Color(0xFFEEE8E8))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: open,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Image.asset(product.mainImage,
                  height: compact ? 140 : 190,
                  width: double.infinity,
                  fit: BoxFit.cover),
              if (showHeart)
                const Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.deerBlood700,
                        child: Icon(Icons.favorite,
                            color: Colors.white, size: 13))),
              if (product.badge != null)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                            color: compact
                                ? AppColors.deerBlood700
                                : const Color(0xD9FFFFFF),
                            borderRadius: BorderRadius.circular(99)),
                        child: Text(product.badge!,
                            style: TextStyle(
                                fontSize: compact ? 11 : 12,
                                fontWeight: FontWeight.w700,
                                color: compact
                                    ? Colors.white
                                    : AppColors.deerBlood700)))),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 12),
                        const SizedBox(width: 4),
                        Text(ArabicNumbers.convert(product.rating),
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700)),
                      ]))),
            ]),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    compact ? 10 : 14, 12, compact ? 10 : 14, 14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: compact ? 14 : 17,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(product.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: compact ? 11 : 13,
                              color: AppColors.textMuted)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text:
                                          '${ArabicNumbers.convert(product.price.toInt())} ج.م',
                                      style: TextStyle(
                                          fontSize: compact ? 15 : 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.deerBlood500)),
                                  TextSpan(
                                      text: ' / ${product.unit}',
                                      style: TextStyle(
                                          fontSize: compact ? 10 : 12,
                                          color: AppColors.textMuted)),
                                ])))),
                        SizedBox(
                            width: compact ? 28 : 36,
                            height: compact ? 28 : 36,
                            child: IconButton(
                                tooltip: 'إضافة',
                                onPressed: open,
                                padding: EdgeInsets.zero,
                                style: IconButton.styleFrom(
                                    backgroundColor: AppColors.deerBlood700,
                                    foregroundColor: Colors.white),
                                icon: const Icon(Icons.add, size: 20))),
                      ]),
                    ])),
          ])),
    );
  }
}

class StoreProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool showHeart;
  const StoreProductGrid(
      {super.key, required this.products, this.showHeart = false});
  @override
  Widget build(BuildContext context) {
    if (products.isEmpty)
      return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('لا توجد منتجات مطابقة للبحث')));
    return LayoutBuilder(
        builder: (context, constraints) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  mainAxisExtent:
                      270 * MediaQuery.textScalerOf(context).scale(1),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              itemCount: products.length,
              itemBuilder: (_, i) => StoreProductCard(
                  product: products[i], compact: true, showHeart: showHeart),
            ));
  }
}

class HomeHero extends StatefulWidget {
  final VoidCallback onShop;
  const HomeHero({super.key, required this.onShop});
  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  int index = 0;
  Timer? timer;
  static const slides = [
    (
      'طـازج من الذبـح إلى بـابك',
      'خصم حتى ٢٠٪ على قطع اللحوم المختارة هذا الأسبوع'
    ),
    ('اطلب ذبيحتك كما تحب', 'تقطيع وتغليف حسب رغبتك وتوصيل مبرد'),
    ('جودة مضمونة كل يوم', 'ذبح يومي تحت إشراف بيطري كامل'),
  ];
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 4500), (_) {
      if (mounted &&
          TickerMode.of(context) &&
          !MediaQuery.disableAnimationsOf(context))
        setState(() => index = (index + 1) % slides.length);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
                height: 180 * MediaQuery.textScalerOf(context).scale(1),
                child: Stack(fit: StackFit.expand, children: [
                  Image.asset('assets/images/product_1.jpg', fit: BoxFit.cover),
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Color(0xF2460A0E), Color(0xC7460A0E)]))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: const Color(0x47FFFFFF),
                                    borderRadius: BorderRadius.circular(99)),
                                child: const Text('عروض الأسبوع',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))),
                            const SizedBox(height: 10),
                            Text(slides[index].$1,
                                style: const TextStyle(
                                    fontSize: 24,
                                    height: 1.25,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(slides[index].$2,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xD9FFFFFF))),
                          ])),
                  Positioned(
                      left: 12,
                      bottom: 12,
                      child: FilledButton(
                          onPressed: widget.onShop,
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3A0D10),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6)),
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chevron_left, size: 14),
                                SizedBox(width: 6),
                                Text('تسوق العرض',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700))
                              ]))),
                ]))),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (i) => GestureDetector(
                    onTap: () => setState(() => index = i),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: i == index
                                    ? AppColors.deerBlood500
                                    : const Color(0xFFD9D4D4),
                                borderRadius: BorderRadius.circular(3))))))),
      ]);
}
