import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('طلباتي السابقة والجارية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard(
            orderId: 'WD-9428',
            status: 'قيد التجهيز والتقطيع',
            statusColor: AppColors.gold,
            date: 'اليوم، ٠٣:٣٠ م',
            items: 'خروف نعيمي بلدي كامل (تقطيع ثلاجة)',
            total: '١,٤٥٠ ج.م',
          ),
          const SizedBox(height: 12),
          _buildOrderCard(
            orderId: 'WD-8910',
            status: 'تم التوصيل بنجاح',
            statusColor: AppColors.success,
            date: 'الأسبوع الماضي، الخميس',
            items: 'ريش غنم بلدي فاخرة (٢ كجم)',
            total: '٧٦٠ ج.م',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String status,
    required Color statusColor,
    required String date,
    required String items,
    required String total,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECE6E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(items, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المبلغ المدفوع', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              Text(total, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deerBlood500)),
            ],
          ),
        ],
      ),
    );
  }
}
