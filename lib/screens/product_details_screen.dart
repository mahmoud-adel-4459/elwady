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
  late List<WeightPreset> _weightPresets;
  int _selectedWeightIdx = 0;
  int _quantity = 1;
  CuttingOption _selectedCut = kCuttingOptions[0];
  PackagingOption _selectedPackaging = kPackagingOptions[0];
  CarcassOption _selectedHead = kHeadOptions[0];
  CarcassOption _selectedOffal = kOffalOptions[0];
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product.isCarcass) {
      _weightPresets = const [
        WeightPreset(label: 'ربع ذبيحة', short: 'ربع ذبيحة', multiplier: 0.25),
        WeightPreset(label: 'نصف ذبيحة', short: 'نصف ذبيحة', multiplier: 0.5),
        WeightPreset(label: 'ذبيحة كاملة', short: 'كاملة', multiplier: 1.0),
      ];
      _selectedWeightIdx = 2; // Default full
    } else {
      _weightPresets = const [
        WeightPreset(label: '500 جم', short: '٥٠٠ جم', multiplier: 0.5),
        WeightPreset(label: '1 كجم', short: '١ كجم', multiplier: 1.0),
        WeightPreset(label: '2 كجم', short: '٢ كجم', multiplier: 2.0),
        WeightPreset(label: '3 كجم', short: '٣ كجم', multiplier: 3.0),
        WeightPreset(label: '5 كجم', short: '٥ كجم', multiplier: 5.0),
      ];
      _selectedWeightIdx = 1; // Default 1kg
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _currentPrice {
    final weight = _weightPresets[_selectedWeightIdx];
    return (widget.product.price * weight.multiplier * _quantity);
  }

  void _handleAddToCart() {
    final weight = _weightPresets[_selectedWeightIdx];
    final cartItem = CartItem(
      product: widget.product,
      weightLabel: weight.label,
      weightMultiplier: weight.multiplier,
      quantity: _quantity,
      cut: _selectedCut.name,
      packaging: _selectedPackaging.name,
      headOption: widget.product.isCarcass ? _selectedHead.name : null,
      offalOption: widget.product.isCarcass ? _selectedOffal.name : null,
      notes: _notesController.text.trim(),
      totalPrice: _currentPrice,
    );

    context.read<AppProvider>().addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 تمت إضافة ${widget.product.title} إلى السلة بنجاح'),
        backgroundColor: AppColors.deerBlood500,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWishlisted = context.watch<AppProvider>().wishlist.contains(product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('تفاصيل وتخصيص المنتج', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward), // RTL Back
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? AppColors.deerBlood500 : AppColors.textPrimary,
            ),
            onPressed: () => context.read<AppProvider>().toggleWishlist(product.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Header
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                product.mainImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: AppColors.surfaceMuted,
                  child: const Icon(Icons.restaurant, size: 60, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Title & Price
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              product.subtitle,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),

            // Price banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEFEAE8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ArabicNumbers.convert(product.price.toInt())} ج.م / ${product.unit}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.deerBlood500),
                  ),
                  Text('⭐ ${product.rating} (${ArabicNumbers.convert(product.reviewsCount)} تقييم)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. Weight Selection
            _buildSectionTitle('اختر الوزن والكمية', 'حدد وزن القطعية أو حجم الذبيحة:'),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _weightPresets.length > 3 ? 3 : _weightPresets.length,
                childAspectRatio: 2.1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _weightPresets.length,
              itemBuilder: (ctx, i) {
                final w = _weightPresets[i];
                final isSelected = i == _selectedWeightIdx;
                final computedPrice = (product.price * w.multiplier).toInt();
                return InkWell(
                  onTap: () => setState(() => _selectedWeightIdx = i),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.deerBlood50 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.deerBlood500 : const Color(0xFFE2DCDC),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(w.short, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary)),
                        Text('${ArabicNumbers.convert(computedPrice)} ج.م', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? AppColors.deerBlood700 : AppColors.textMuted)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Quantity Stepper
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFECE5E2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الكمية المطلوبة:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.deerBlood500,
                      ),
                      Text(
                        ArabicNumbers.convert(_quantity),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle),
                        color: AppColors.deerBlood500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Cutting Options
            _buildSectionTitle('طريقة التقطيع والتجهيز', 'يتم التجهيز فوراً بأجهزة معقمة:'),
            const SizedBox(height: 10),
            Column(
              children: kCuttingOptions.map((c) {
                final isSelected = c.id == _selectedCut.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCut = c),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.deerBlood50 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.deerBlood500 : const Color(0xFFE2DCDC),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(c.icon, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              c.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.deerBlood500, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Carcass Specifics
            if (product.isCarcass) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('تجهيز الرأس', null),
              const SizedBox(height: 8),
              Row(
                children: kHeadOptions.map((h) {
                  final isSelected = h.id == _selectedHead.id;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () => setState(() => _selectedHead = h),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected ? AppColors.deerBlood50 : Colors.white,
                          side: BorderSide(color: isSelected ? AppColors.deerBlood500 : const Color(0xFFE2DCDC)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          h.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // 3. Packaging Options
            _buildSectionTitle('طريقة التغليف والحفظ', 'تغليف صحي يحفظ طراوة اللحوم:'),
            const SizedBox(height: 10),
            Column(
              children: kPackagingOptions.map((p) {
                final isSelected = p.id == _selectedPackaging.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedPackaging = p),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.deerBlood50 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.deerBlood500 : const Color(0xFFE2DCDC),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(p.desc, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.deerBlood500, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 4. Notes
            _buildSectionTitle('ملاحظات خاصة للقصاب', 'أي طلبات إضافية بخصوص التشفية أو العظام:'),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'مثال: يرجى تقطيع الضلوع منفصلة، وفصل الشحم...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFFAFAF8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2DCDC)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFECE6E4))),
          boxShadow: [
            BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -3)),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الإجمالي', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                Text(
                  '${ArabicNumbers.convert(_currentPrice.toInt())} ج.م',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.deerBlood500),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _handleAddToCart,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deerBlood500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String? subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ],
    );
  }
}
