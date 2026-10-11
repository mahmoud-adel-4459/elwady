import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../providers/app_provider.dart';
import '../widgets/store_widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final listing = app.categoryListing || app.searchQuery.trim().isNotEmpty;
    const pills = [
      ('all', 'الكل'),
      ('offers', 'العروض'),
      ('fresh_cuts', 'اللحوم الطازجة'),
      ('carcasses', 'الذبائح')
    ];
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: Column(children: [
              const StoreHeader(),
              Expanded(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const StoreSearch(compact: true),
                            if (app.categoryListing) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 34,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: pills.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (_, i) => ChoiceChip(
                                        showCheckmark: false,
                                        label: Text(pills[i].$2),
                                        selected:
                                            app.currentCategory == pills[i].$1,
                                        selectedColor: AppColors.deerBlood700,
                                        backgroundColor: Colors.white,
                                        labelStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: app.currentCategory ==
                                                    pills[i].$1
                                                ? Colors.white
                                                : AppColors.textSecondary),
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                            color: Color(0xFFE2DCDC)),
                                        onSelected: (_) =>
                                            app.setCategory(pills[i].$1))),
                              ),
                              const SizedBox(height: 14),
                              HomeHero(onShop: () => app.setCategory('offers')),
                            ],
                            if (listing) ...[
                              const SizedBox(height: 16),
                              Text(
                                  '${ArabicNumbers.convert(app.filteredProducts.length)} منتجات متاحة',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted)),
                              const SizedBox(height: 10),
                              StoreProductGrid(products: app.filteredProducts),
                            ] else ...[
                              const SizedBox(height: 18),
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: categoryCards.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 14,
                                          mainAxisSpacing: 16,
                                          mainAxisExtent:
                                              (MediaQuery.sizeOf(context)
                                                              .width -
                                                          46) /
                                                      2 *
                                                      .95 +
                                                  36),
                                  itemBuilder: (_, i) {
                                    final cat = categoryCards[i];
                                    return InkWell(
                                        onTap: () => app.openCategory(cat.id),
                                        child: Column(children: [
                                          Expanded(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.asset(cat.image!,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          categoryImageAlignment(
                                                              cat.id)))),
                                          const SizedBox(height: 8),
                                          Text(cat.name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800)),
                                        ]));
                                  }),
                            ],
                          ]))),
            ])));
  }
}
