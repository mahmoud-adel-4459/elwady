import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/app_provider.dart';
import '../models/delivery_address.dart';
import '../widgets/design_widgets.dart';
import '../widgets/store_widgets.dart';

Future<void> selectDeliveryAddress(
    BuildContext context, DeliveryAddress address) async {
  final app = context.read<AppProvider>();
  if (app.currentAddress.id == address.id) return;
  if (app.cartItems.isNotEmpty) {
    final confirmed = await showDialog<bool>(
        context: context,
        barrierColor: const Color(0x73000000),
        builder: (dialogContext) => Dialog(
              insetPadding: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFFFF4DC),
                        child: Icon(Icons.warning_amber,
                            color: Color(0xFFF59A23), size: 22)),
                    const SizedBox(height: 12),
                    const Text('تأكيد تغيير العنوان',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text(
                        'في حالة تغيير العنوان سيؤثر ذلك على بعض منتجاتك في السلة، حسب المتوفر في منطقتك الجديدة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.7,
                            color: Color(0xFF55504D))),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(
                          child: PrimaryButton(
                              label: 'تغيير العنوان',
                              height: 42,
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: PrimaryButton(
                              label: 'إلغاء',
                              height: 42,
                              outlined: true,
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false))),
                    ]),
                  ])),
            ));
    if (confirmed != true) return;
  }
  app.selectAddress(address);
}

Future<void> showAddresses(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (_) => const AddressesSheet());

class AddressesSheet extends StatelessWidget {
  const AddressesSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .88),
        child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(children: [
              Row(children: [
                const Expanded(
                    child: Text('العناوين',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800))),
                IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20))
              ]),
              for (final address in app.addresses)
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: address.id == app.currentAddress.id
                                    ? const Color(0xFF2F80ED)
                                    : const Color(0xFFE9E3E3),
                                width: address.id == app.currentAddress.id
                                    ? 1.5
                                    : 1)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text(
                                        address.label
                                            .replaceAll(' (الافتراضي)', ''),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted))),
                                if (address.id == app.currentAddress.id)
                                  const Text('العنوان الأساسي',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2F6FD1)))
                              ]),
                              const SizedBox(height: 6),
                              Text(address.address,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                              const Text('الرياض، المملكة العربية السعودية',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted)),
                              const SizedBox(height: 10),
                              InkWell(
                                  onTap: () =>
                                      selectDeliveryAddress(context, address),
                                  child: Row(children: [
                                    Icon(
                                        address.id == app.currentAddress.id
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 14,
                                        color: const Color(0xFF2F6FD1)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        child: Text(
                                            address.id == app.currentAddress.id
                                                ? 'معين كعنوان افتراضي'
                                                : 'تعيين كعنوان افتراضي',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700))),
                                    const Icon(Icons.edit_outlined, size: 11),
                                    const Text(' تعديل   حذف',
                                        style: TextStyle(fontSize: 11)),
                                  ])),
                            ]))),
              const SizedBox(height: 6),
              PrimaryButton(
                  label: '+ إضافة عنوان جديد',
                  height: 50,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const LocationPickerScreen()))),
            ])));
  }
}

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/images/product_2.jpg', fit: BoxFit.cover),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(22))),
                child: SafeArea(
                    bottom: false,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ScreenHeading(
                              title: 'اختر منطقة التوصيل',
                              fontSize: 17,
                              onBack: () => Navigator.pop(context)),
                          TextField(
                              decoration: designInput('ابحث عن حيك أو مدينتك',
                                  icon: Icons.search)),
                          const SizedBox(height: 10),
                          const DesignPanel(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              radius: 12,
                              child: Row(children: [
                                Icon(Icons.location_on_outlined,
                                    size: 14, color: AppColors.deerBlood700),
                                SizedBox(width: 6),
                                Expanded(
                                    child: Text(
                                        'موقعك الحالي: حي الياسمين، الرياض',
                                        style: TextStyle(fontSize: 12)))
                              ])),
                        ]))))),
        const Center(
            child: Icon(Icons.location_on,
                size: 44, color: AppColors.deerBlood700)),
        Positioned(
            left: 20,
            bottom: 96,
            child: IconButton(
                tooltip: 'موقعي',
                onPressed: () {},
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                icon: const Icon(Icons.navigation_outlined, size: 18))),
        Positioned(
            left: 20,
            right: 20,
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
            child: PrimaryButton(
                label: 'تأكيد المنطقة',
                height: 52,
                onPressed: () => Navigator.pop(context))),
      ]));
}

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    Widget field(String label, String value, IconData icon,
            void Function(String) save,
            {bool ltr = false}) =>
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFFF6EEEE),
              child: Icon(icon, size: 16, color: AppColors.deerBlood500)),
          title: Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          subtitle: Text(value,
              textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          trailing: IconButton(
              tooltip: 'تعديل $label',
              icon: const Icon(Icons.edit_outlined, size: 15),
              onPressed: () async {
                final controller = TextEditingController(text: value);
                final updated = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            title: Text(label),
                            content: TextField(
                                controller: controller,
                                autofocus: true,
                                textDirection: ltr
                                    ? TextDirection.ltr
                                    : TextDirection.rtl),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('إلغاء')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, controller.text),
                                  child: const Text('حفظ'))
                            ]));
                if (updated != null) save(updated);
                // The route transition must finish before disposing its field controller.
                await Future<void>.delayed(const Duration(milliseconds: 300));
                controller.dispose();
              }),
        );
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                children: [
          ScreenHeading(
              title: 'المعلومات الشخصية', onBack: () => Navigator.pop(context)),
          const Center(
              child: CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.deerBlood50,
                  child: Text('🧑‍🍳', style: TextStyle(fontSize: 44)))),
          const SizedBox(height: 8),
          Text(app.customerName,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          DesignPanel(
              padding: EdgeInsets.zero,
              radius: 16,
              child: Column(children: [
                field('الاسم الكامل', app.customerName, Icons.person_outline,
                    (v) => app.updateProfile(name: v)),
                const Divider(height: 1),
                field('البريد الإلكتروني', app.customerEmail,
                    Icons.mail_outline, (v) => app.updateProfile(email: v),
                    ltr: true),
                const Divider(height: 1),
                field('رقم الهاتف', app.customerPhone, Icons.phone_outlined,
                    (v) => app.updateProfile(phone: v),
                    ltr: true),
              ])),
          const SizedBox(height: 14),
          const DesignPanel(
              padding: EdgeInsets.zero,
              radius: 16,
              child: ListTile(
                  leading: Icon(Icons.person_remove_outlined,
                      color: AppColors.deerBlood500),
                  title: Text('حذف الحساب',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  subtitle: Text('حذف نهائي للحساب',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  trailing: Icon(Icons.chevron_left, size: 16))),
        ])));
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final products =
        app.products.where((p) => app.wishlist.contains(p.id)).toList();
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(children: [
                  ScreenHeading(
                      title: 'المفضلة', onBack: () => Navigator.pop(context)),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text('${products.length} منتجات متاحة',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted))),
                  const SizedBox(height: 10),
                  StoreProductGrid(products: products, showHeart: true),
                ]))));
  }
}
