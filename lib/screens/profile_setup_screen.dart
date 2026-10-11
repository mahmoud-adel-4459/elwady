import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';

const List<String> kSaudiCities = [
  'الرياض',
  'جدة',
  'مكة المكرمة',
  'المدينة المنورة',
  'الدمام',
  'الخبر',
  'القصيم (بريدة / عنيزة)',
  'الهفوف والأحساء',
  'أبها وخميس مشيط',
  'تبوك',
  'الطائف',
];

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedCity = kSaudiCities[0];
  bool _agreeTerms = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.length < 3) {
      setState(() {
        _errorMessage = 'يرجى إدخال الاسم الكامل (3 أحرف على الأقل)';
      });
      return;
    }
    if (!_agreeTerms) {
      setState(() {
        _errorMessage = 'يرجى الموافقة على الشروط والأحكام للمتابعة';
      });
      return;
    }

    setState(() => _errorMessage = null);

    context.read<AppProvider>().completeProfileSetup(
          name: name,
          email: _emailController.text.trim(),
          city: _selectedCity,
        );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'اختر المدينة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: kSaudiCities.length,
                  itemBuilder: (ctx, idx) {
                    final city = kSaudiCities[idx];
                    final isSelected = city == _selectedCity;
                    return ListTile(
                      onTap: () {
                        setState(() => _selectedCity = city);
                        Navigator.pop(ctx);
                      },
                      leading: Icon(
                        Icons.location_on,
                        color: isSelected ? AppColors.deerBlood500 : Colors.grey,
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.deerBlood500 : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.deerBlood500)
                          : null,
                    );
                  },
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: ActionChip(
            onPressed: () {
              context.read<AppProvider>().setFlow(AppFlow.main);
            },
            label: const Text(
              'تخطي الآن',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66615E),
              ),
            ),
            backgroundColor: AppColors.surfaceMuted,
            shape: const StadiumBorder(),
            side: BorderSide.none,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Burgundy Logo
              Image.asset(
                'assets/images/logo_alwadi_burgundy.png',
                width: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.restaurant,
                  size: 80,
                  color: AppColors.deerBlood500,
                ),
              ),
              const SizedBox(height: 18),

              // Headings
              Text(
                'استكمال البيانات',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'مرحباً بك في الوادي للذبائح! نرجو إدخال بياناتك الأساسية لتجهيز وتوصيل طلباتك بأعلى جودة.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 28),

              // 1. Full Name Field
              _buildFieldLabel('الاسم الكامل *'),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                decoration: _buildInputDecoration(
                  hint: 'مثال: أحمد عبد الله',
                  prefixIcon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 16),

              // 2. City Selector Field
              _buildFieldLabel('المدينة *'),
              const SizedBox(height: 6),
              InkWell(
                onTap: _showCityPicker,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2DCDC), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.deerBlood500, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedCity,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Email Field (Optional)
              _buildFieldLabel('البريد الإلكتروني (اختياري)'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 15),
                decoration: _buildInputDecoration(
                  hint: 'name@example.com',
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 20),

              // Terms Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    activeColor: AppColors.deerBlood500,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'أوافق على الشروط والأحكام وسياسة الخصوصية لمنصة الوادي.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 54px Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deerBlood500,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'حفظ ومتابعة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAFA7A4), fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: AppColors.textMuted, size: 20),
      filled: true,
      fillColor: const Color(0xFFFAFAF8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2DCDC), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.deerBlood500, width: 2),
      ),
    );
  }
}
