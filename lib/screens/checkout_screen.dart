import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../core/utils/arabic_numbers.dart';
import '../providers/app_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'mada';

  void _handleConfirm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 45, color: AppColors.success),
              ),
              const SizedBox(height: 18),
              const Text(
                'تم تأكيد طلبك بنجاح!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'تم توجيه الذبيحة لأقرب مسلخ وبدء التجهيز والتقطيع الفوري.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AppProvider>().clearCart();
                    context.read<AppProvider>().setTab(3); // Go to Orders tab
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deerBlood500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('متابعة حالة الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إتمام وتأكيد الطلب', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward), // RTL Back
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECE6E4)),
              ),
              child: Column(
                children: [
                  _buildRow(Icons.location_on, 'التوصيل إلى', provider.deliveryAddress),
                  const Divider(height: 20),
                  _buildRow(Icons.local_shipping, 'طريقة الشحن', 'سيارات مبردة ومعقمة'),
                  const Divider(height: 20),
                  _buildRow(Icons.access_time, 'الوقت المتوقع', 'خلال الموعد المختار'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Pricing details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECE6E4)),
              ),
              child: Column(
                children: [
                  _buildPriceRow('المجموع الفرعي', '${ArabicNumbers.convert(provider.cartSubtotal.toInt())} ج.م'),
                  const SizedBox(height: 8),
                  _buildPriceRow('رسوم التوصيل', '${ArabicNumbers.convert(provider.deliveryFee.toInt())} ج.م'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('المبلغ الإجمالي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      Text(
                        '${ArabicNumbers.convert(provider.cartTotal.toInt())} ج.م',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.deerBlood500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Payment Methods
            const Text('طرق الدفع المتاحة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildPaymentTile('mada', 'بطاقة مدى / ماستركارد', Icons.credit_card),
                _buildPaymentTile('applepay', 'Apple Pay', Icons.phone_iphone),
                _buildPaymentTile('visa', 'فيزا كارد (Visa)', Icons.payment),
                _buildPaymentTile('cash', 'الدفع نقداً أو شبكة عند الاستلام', Icons.money),
              ],
            ),
            const SizedBox(height: 16),

            // Quality Guarantee Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD6EAD6)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified_user, color: AppColors.success, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ضمان الجودة الذهبي: ذبح حلال طازج ١٠٠٪ بإشراف بيطري كامل.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                  ),
                ],
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
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _handleConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deerBlood500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'تأكيد الطلب الآن (${ArabicNumbers.convert(provider.cartTotal.toInt())} ج.م)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.deerBlood500),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildPaymentTile(String id, String title, IconData icon) {
    final isSelected = _selectedPayment == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedPayment = id),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.deerBlood50 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.deerBlood500 : const Color(0xFFECE6E4),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.deerBlood500 : AppColors.textSecondary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary,
                  ),
                ),
              ),
              Radio<String>(
                value: id,
                groupValue: _selectedPayment,
                activeColor: AppColors.deerBlood500,
                onChanged: (val) => setState(() => _selectedPayment = val!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
