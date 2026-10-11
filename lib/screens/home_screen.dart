import '../core/utils/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../widgets/store_widgets.dart';
import '../models/product.dart';
import '../providers/app_provider.dart';

// Reference: the mobile layout used by App.jsx and HomeSections.jsx.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categories = ScrollController();
  @override
  void dispose() {
    categories.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final listing = app.currentCategory != 'all' || app.searchQuery.isNotEmpty;
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: Column(children: [
              const StoreHeader(),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StoreSearch(),
                      if (listing) ...[
                        Row(children: [
                          IconButton(
                              tooltip: 'رجوع',
                              onPressed: () {
                                app.setCategory('all');
                                app.setSearch('');
                              },
                              icon: const Icon(Icons.arrow_forward)),
                          Expanded(
                              child: Text(
                                  app.searchQuery.isNotEmpty
                                      ? 'نتائج البحث'
                                      : categoryCards
                                          .firstWhere((c) =>
                                              c.id == app.currentCategory)
                                          .name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800))),
                        ]),
                        HomeHero(onShop: () => app.setCategory('offers')),
                        const SizedBox(height: 16),
                        Text(
                            '${ArabicNumbers.convert(app.filteredProducts.length)} منتجات متاحة',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 10),
                        StoreProductGrid(products: app.filteredProducts),
                      ] else ...[
                        const SizedBox(height: 22),
                        HomeHero(onShop: () => app.setCategory('offers')),
                        const SizedBox(height: 18),
                        Row(children: [
                          _feature('جودة مضمونة', 'feature-quality.png'),
                          const SizedBox(width: 10),
                          _feature('ذبح يومي', 'feature-daily.png'),
                          const SizedBox(width: 10),
                          _feature('توصيل سريع', 'feature-delivery.png'),
                        ]),
                        _section('الأقسام', () => app.setTab(1)),
                        SizedBox(
                            height: 124,
                            child: ListView.separated(
                              controller: categories,
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryCards
                                  .where((c) => c.id != 'extras')
                                  .length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, i) {
                                final cat = categoryCards
                                    .where((c) => c.id != 'extras')
                                    .elementAt(i);
                                return SizedBox(
                                    width: 92,
                                    child: InkWell(
                                        onTap: () => app.setCategory(cat.id),
                                        child: Column(children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: Image.asset(cat.image!,
                                                  width: 92,
                                                  height: 88,
                                                  alignment:
                                                      categoryImageAlignment(
                                                          cat.id),
                                                  fit: BoxFit.cover)),
                                          const SizedBox(height: 6),
                                          Text(cat.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              softWrap: false,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700)),
                                        ])));
                              },
                            )),
                        const SizedBox(height: 8),
                        _CarouselControls(controller: categories, step: 104),
                        _section('الأكثر طلباً',
                            () => app.setCategory('fresh_cuts')),
                        _products(
                            context,
                            app.products
                                .where((p) => p.id != 1)
                                .take(4)
                                .toList()),
                        const SizedBox(height: 22),
                        _promo(context, () => app.setCategory('carcasses')),
                        _section('عروض مميزة', () => app.setCategory('offers')),
                        _products(
                            context, app.products.skip(1).take(4).toList()),
                      ],
                    ]),
              )),
            ])));
  }

  Widget _feature(String label, String image) => Expanded(
          child: Container(
        height: 88,
        decoration: BoxDecoration(
            color: const Color(0xFFEFEDED),
            borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/$image',
              width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
        ]),
      ));
  Widget _section(String title, VoidCallback onAll) => Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          InkWell(
              onTap: onAll,
              child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('الكل',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMuted)))),
        ]),
      );
  Widget _products(BuildContext context, List<Product> products) =>
      _ProductCarousel(products: products);
  Widget _promo(BuildContext context, VoidCallback onOrder) => Container(
        height: (MediaQuery.sizeOf(context).width * .46).clamp(170.0, 200.0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF111110), Color(0xFF191817)]),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF302B25))),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Text('عروض الوادي',
                    style: TextStyle(fontSize: 13, color: Color(0xFFDCA878))),
                const SizedBox(height: 8),
                const Expanded(
                    child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('اطلب ذبيحة كاملة\nووفر 15٪',
                                style: TextStyle(
                                    fontSize: 24,
                                    height: 1.15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFF9EBDF)))))),
                const SizedBox(height: 10),
                SizedBox(
                    height: 34,
                    child: FilledButton(
                        onPressed: onOrder,
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.deerBlood500,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 5),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        child: const Text('اطلب الآن',
                            style: TextStyle(fontSize: 15)))),
              ])),
          const SizedBox(width: 16),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/steak.jpg',
                  width: (MediaQuery.sizeOf(context).width - 84) * .43,
                  height: double.infinity,
                  fit: BoxFit.cover)),
        ]),
      );
}

class _CarouselControls extends StatelessWidget {
  final ScrollController controller;
  final double step;
  const _CarouselControls({required this.controller, required this.step});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: controller,
      builder: (context, _) =>
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            for (final direction in [-1, 1]) ...[
              SizedBox(
                  width: 34,
                  height: 34,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                          side: const BorderSide(color: Color(0xFFEEE8E8))),
                      onPressed: (!controller.hasClients ||
                                  !controller.position.hasContentDimensions
                              ? direction > 0
                              : (direction < 0
                                  ? controller.offset > 2
                                  : controller.offset <
                                      controller.position.maxScrollExtent - 2))
                          ? () => controller.animateTo(
                              (controller.offset + step * direction).clamp(
                                  0.0, controller.position.maxScrollExtent),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut)
                          : null,
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child:
                              Icon(direction < 0 ? Icons.chevron_right : Icons.chevron_left, size: 18)))),
              if (direction < 0) const SizedBox(width: 8),
            ]
          ]));
}

class _ProductCarousel extends StatefulWidget {
  final List<Product> products;
  const _ProductCarousel({required this.products});
  @override
  State<_ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<_ProductCarousel> {
  final controller = ScrollController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
            height: 340 * MediaQuery.textScalerOf(context).scale(1),
            child: ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(
                    width: 224,
                    child: StoreProductCard(product: widget.products[i])))),
        const SizedBox(height: 10),
        _CarouselControls(controller: controller, step: 236),
      ]);
}
