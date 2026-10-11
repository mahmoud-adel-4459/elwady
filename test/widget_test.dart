import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alwady_app/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:alwady_app/providers/app_provider.dart';
import 'package:alwady_app/screens/home_screen.dart';
import 'package:alwady_app/screens/categories_screen.dart';
import 'package:alwady_app/screens/onboarding_screen.dart';
import 'package:alwady_app/screens/main_navigation_screen.dart';

Widget host(AppProvider app, Widget screen) => ChangeNotifierProvider.value(
      value: app,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [Locale('ar', 'SA')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    );

void main() {
  setUpAll(() async {
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
    testWidgets('Home fits an Arabic mobile viewport of $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final app = AppProvider();
      await tester.pumpWidget(host(app, const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('جودة مضمونة'), findsOneWidget);
      expect(find.text('ذبح يومي'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      app.dispose();
    });
  }

  testWidgets('Search keeps focus, filters results and clears via back',
      (tester) async {
    final app = AppProvider();
    await tester.pumpWidget(host(app, const HomeScreen()));
    await tester.enterText(find.byType(TextField), 'ريش');
    await tester.pumpAndSettle();
    expect(find.text('نتائج البحث'), findsOneWidget);
    expect(find.text('ريش غنم بلدي فاخرة'), findsOneWidget);
    expect(find.text('لحم مفروم بلدي طازج'), findsNothing);
    await tester.enterText(find.byType(TextField), 'منتج غير موجود');
    await tester.pumpAndSettle();
    expect(find.text('لا توجد منتجات مطابقة للبحث'), findsOneWidget);
    await tester.tap(find.byTooltip('رجوع'));
    await tester.pumpAndSettle();
    expect(app.searchQuery, isEmpty);
    expect(app.currentCategory, 'all');
    expect(find.text('جودة مضمونة'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  });

  testWidgets('Category images open a filtered listing', (tester) async {
    final app = AppProvider();
    await tester.pumpWidget(host(app, const CategoriesScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('اللحوم الطازجة'));
    await tester.pumpAndSettle();
    expect(app.currentCategory, 'fresh_cuts');
    expect(find.text('ريش غنم بلدي فاخرة'), findsOneWidget);
    expect(find.text('خروف نعيمي كامل بلدي'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  });

  testWidgets('Onboarding advances through all three React slides',
      (tester) async {
    final app = AppProvider()..setFlow(AppFlow.onboarding);
    await tester.pumpWidget(host(app, const OnboardingScreen()));
    await tester.pumpAndSettle();
    expect(find.text('لحوم فاخرة تصل إلى بابك'), findsOneWidget);
    await tester.ensureVisible(find.text('التالي'));
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('اختر تقطيعك وكمياتك'), findsOneWidget);
    await tester.ensureVisible(find.text('التالي'));
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('منتجات متاحة حسب منطقتك'), findsOneWidget);
    await tester.ensureVisible(find.text('ابدأ التسوق'));
    await tester.tap(find.text('ابدأ التسوق'));
    expect(app.currentFlow, AppFlow.login);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  });

  testWidgets('Floating navigation opens categories and profile',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final app = AppProvider();
    await tester.pumpWidget(host(app, const MainNavigationScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الأقسام').last);
    await tester.pumpAndSettle();
    expect(app.currentTab, 1);
    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    expect(app.currentTab, 4);
    expect(find.text('المعلومات الشخصية'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  });
}
