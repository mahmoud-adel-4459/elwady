import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alwady_app/models/order_summary.dart';
import 'package:alwady_app/models/cart_item.dart';
import 'package:alwady_app/providers/app_provider.dart';
import 'package:alwady_app/screens/splash_screen.dart';
import 'package:alwady_app/screens/login_screen.dart';
import 'package:alwady_app/screens/onboarding_screen.dart';
import 'package:alwady_app/screens/otp_screen.dart';
import 'package:alwady_app/screens/profile_setup_screen.dart';
import 'package:alwady_app/screens/location_permission_screen.dart';
import 'package:alwady_app/screens/main_navigation_screen.dart';
import 'package:alwady_app/screens/product_details_screen.dart';
import 'package:alwady_app/screens/checkout_screen.dart';
import 'package:alwady_app/screens/thank_you_screen.dart';
import 'package:alwady_app/screens/order_tracking_screen.dart';
import 'package:alwady_app/screens/account_screens.dart';
import 'package:alwady_app/screens/notifications_screen.dart';
import 'widget_test.dart' show host;

void main() {
  setUpAll(() async {
    final emojiFile = File('C:/Windows/Fonts/seguiemj.ttf');
    if (emojiFile.existsSync()) {
      final emoji = FontLoader('Segoe UI Emoji')
        ..addFont(
            Future.value(ByteData.sublistView(emojiFile.readAsBytesSync())));
      await emoji.load();
    }
    final loader = FontLoader('Cairo');
    for (final weight in [400, 500, 600, 700, 800]) {
      loader.addFont(rootBundle.load('assets/fonts/Cairo-$weight.ttf'));
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  for (final width in [320.0, 390.0, 430.0]) {
    testWidgets('All application screens render at $width', (tester) async {
      final previousShadows = debugDisableShadows;
      debugDisableShadows = false;
      addTearDown(() => debugDisableShadows = previousShadows);
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final app = AppProvider();
      final order = OrderSummary(
          subtotal: 380,
          deliveryFee: 25,
          date: DateTime(2026, 10, 11),
          slot: '10:00 ص - 12:00 م',
          address: app.currentAddress);
      Future<void> capture(String name, Widget screen,
          {Duration delay = const Duration(milliseconds: 500),
          Future<void> Function()? action}) async {
        final key = GlobalKey();
        await tester
            .pumpWidget(RepaintBoundary(key: key, child: host(app, screen)));
        await tester.pump(delay);
        await tester.pump(name == 'splash-cleavers'
            ? Duration.zero
            : const Duration(milliseconds: 1200));
        if (action != null) {
          await action();
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull, reason: '$name at $width');
        Future<void> save(String filename) async {
          if (width != 390 ||
              Platform.environment['CAPTURE_SCREENSHOTS'] != '1') return;
          final boundary =
              key.currentContext!.findRenderObject() as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final png = await boundary.toImage(pixelRatio: 1);
            final bytes = await png.toByteData(format: ui.ImageByteFormat.png);
            await Directory('verification/flutter').create(recursive: true);
            await File('verification/flutter/$filename.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            png.dispose();
          });
        }

        await save(name);
        final scrollables = find.byWidgetPredicate((widget) =>
            widget is Scrollable &&
            (widget.axisDirection == AxisDirection.down ||
                widget.axisDirection == AxisDirection.up));
        if (scrollables.evaluate().isNotEmpty) {
          final scroll =
              tester.state<ScrollableState>(scrollables.first).position;
          if (scroll.maxScrollExtent > 0) {
            scroll.jumpTo(scroll.maxScrollExtent);
            await tester.pump();
            expect(tester.takeException(), isNull,
                reason: '$name bottom at $width');
            await save('$name-bottom');
          }
        }
        await tester.pumpWidget(const SizedBox());
      }

      await capture('splash-cleavers', const SplashScreen(),
          delay: const Duration(milliseconds: 400));
      await capture('splash-logo', const SplashScreen(),
          delay: const Duration(milliseconds: 1700));
      await capture('login', const LoginScreen());
      await capture('countries', const LoginScreen(),
          action: () => tester.tap(find.text('+966')));
      for (var slide = 1; slide <= 3; slide++) {
        await capture('onboarding-$slide', const OnboardingScreen(),
            action: () async {
          for (var index = 1; index < slide; index++) {
            await tester.ensureVisible(find.text('التالي'));
            await tester.tap(find.text('التالي'));
            await tester.pump(const Duration(milliseconds: 400));
          }
        });
      }
      await capture('otp', const OtpScreen());
      await capture('profile-setup', const ProfileSetupScreen());
      await capture('location-permission', const LocationPermissionScreen());
      for (final entry in {
        0: 'home',
        1: 'categories',
        2: 'cart-empty',
        3: 'orders-current',
        4: 'profile'
      }.entries) {
        app.setTab(entry.key);
        if (entry.key == 2) {
          while (app.cartItems.isNotEmpty) {
            app.updateQuantity(0, 0);
          }
        }
        await capture(entry.value, const MainNavigationScreen());
      }
      await capture(
          'product-details', ProductDetailsScreen(product: app.products[1]));
      await capture(
          'carcass-details', ProductDetailsScreen(product: app.products[0]));
      app.setTab(1);
      app.openCategory('fresh_cuts');
      await capture('category-listing', const MainNavigationScreen());
      app.setTab(0);
      app.setSearch('ريش');
      await capture('search-results', const MainNavigationScreen());
      app.setSearch('');
      app.setCategory('all');
      app.addToCart(CartItem(
          product: app.products[1],
          weightLabel: '1 كيلو',
          weightMultiplier: 1,
          quantity: 1,
          cut: 'مكعبات',
          packaging: 'تغليف عادي',
          notes: '',
          totalPrice: 380));
      app.setTab(2);
      await capture('cart', const MainNavigationScreen());
      await capture('checkout', CheckoutScreen(order: order));
      await capture('thank-you', ThankYouScreen(order: order));
      await capture('order-tracking', const OrderTrackingScreen());
      await capture('personal-info', const PersonalInfoScreen());
      await capture('location-picker', const LocationPickerScreen());
      await capture('favorites', const FavoritesScreen());
      await capture('notifications', const NotificationsScreen());
      app.setTab(4);
      await capture('addresses', const MainNavigationScreen(),
          action: () async {
        showAddresses(tester.element(find.byType(MainNavigationScreen)));
      });
      await capture('location-guard', const MainNavigationScreen(),
          action: () async {
        showAddresses(tester.element(find.byType(MainNavigationScreen)));
        await tester.pumpAndSettle();
        selectDeliveryAddress(
            tester.element(find.byType(AddressesSheet)), app.addresses[1]);
      });
      await capture('weight-adjustment', const NotificationsScreen(),
          action: () async {
        showWeightNotice(tester.element(find.byType(NotificationsScreen)));
      });
      app.setTab(3);
      await capture('orders-previous', const MainNavigationScreen(),
          action: () => tester.tap(find.text('السابقة')));
      app.dispose();
      debugDisableShadows = previousShadows;
    });
  }
}
