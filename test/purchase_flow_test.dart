import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alwady_app/providers/app_provider.dart';
import 'package:alwady_app/screens/main_navigation_screen.dart';
import 'package:alwady_app/screens/product_details_screen.dart';
import 'package:alwady_app/screens/checkout_screen.dart';
import 'package:alwady_app/screens/thank_you_screen.dart';
import 'package:alwady_app/screens/order_tracking_screen.dart';
import 'widget_test.dart' show host;

void main() {
  setUpAll(() async {
    final loader = FontLoader('Cairo');
    for (final weight in [400, 500, 600, 700, 800]) {
      loader.addFont(rootBundle.load('assets/fonts/Cairo-$weight.ttf'));
    }
    await loader.load();
  });
  testWidgets(
      'Product customization, cart, checkout and tracking form a complete journey',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final app = AppProvider()
      ..setTab(1)
      ..openCategory('fresh_cuts');
    await tester.pumpWidget(host(app, const MainNavigationScreen()));
    await tester.pumpAndSettle();
    final product = find.text(app.products[1].title).first;
    await tester.ensureVisible(product);
    await tester.tap(product);
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    final before = app.cartItems.length;
    await tester.tap(find.text('إضافة إلى السلة'));
    await tester.pumpAndSettle();
    expect(app.cartItems.length, before + 1);
    final price = app.cartItems.first.totalPrice;
    app.updateQuantity(0, 2);
    expect(app.cartItems.first.totalPrice, price * 2);
    app.updateQuantity(0, 1);
    expect(app.cartItems.first.totalPrice, price);
    app.setTab(2);
    await tester.pumpAndSettle();
    final pay = find.textContaining('متابعة الدفع');
    await tester.ensureVisible(pay);
    await tester.tap(pay);
    await tester.pumpAndSettle();
    expect(find.byType(CheckoutScreen), findsOneWidget);
    final total = app.cartTotal;
    await tester.tap(find.textContaining('تأكيد الطلب الآن'));
    await tester.pumpAndSettle();
    expect(find.byType(ThankYouScreen), findsOneWidget);
    expect(app.cartItems, isEmpty);
    expect(app.completedOrder!.total, total);
    await tester.tap(find.text('متابعة الطلب ←'));
    await tester.pumpAndSettle();
    expect(app.currentTab, 3);
    await tester.tap(find.text('تتبع الطلب').first);
    await tester.pumpAndSettle();
    expect(find.byType(OrderTrackingScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  });

  test('Existing and new phone numbers keep React authentication routing', () {
    final app = AppProvider();
    app.submitPhoneNumber('501234567', '+966');
    app.verifyOtpSuccess();
    expect(app.currentFlow, AppFlow.locationPermission);
    app.submitPhoneNumber('599000001', '+966');
    app.verifyOtpSuccess();
    expect(app.currentFlow, AppFlow.profileSetup);
    app.completeProfileSetup(name: 'محمد', email: '', city: 'الرياض');
    expect(app.currentFlow, AppFlow.locationPermission);
    expect(app.customerName, 'محمد');
    app.dispose();
  });
}
