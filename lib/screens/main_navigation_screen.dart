import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    const pages = [
      HomeScreen(),
      CategoriesScreen(),
      CartScreen(),
      OrdersScreen(),
      ProfileScreen()
    ];
    const labels = ['الرئيسية', 'الأقسام', 'السلة', 'الطلبات', 'حسابي'];
    const icons = ['home', 'categories', 'cart', 'orders', 'profile'];
    return Scaffold(
        body: Stack(children: [
      IndexedStack(
          index: app.currentTab,
          children: List.generate(
              pages.length,
              (i) =>
                  TickerMode(enabled: app.currentTab == i, child: pages[i]))),
      Positioned(
          left: 16,
          right: 16,
          bottom: 14 + MediaQuery.paddingOf(context).bottom,
          child: Center(
              child: Container(
            constraints: const BoxConstraints(maxWidth: 390),
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xA6E4DCD6)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x1F2D1E1E),
                      blurRadius: 36,
                      spreadRadius: -4,
                      offset: Offset(0, 12)),
                  BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 2)),
                ]),
            child: Row(
                children: List.generate(5, (i) {
              final selected = app.currentTab == i;
              final color =
                  selected ? const Color(0xFF741018) : const Color(0xFF8E827E);
              return Expanded(
                  child: Semantics(
                selected: selected,
                button: true,
                label: labels[i],
                child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      app.setTab(i);
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 24,
                              height: 26,
                              child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/nav_${i == 0 && selected ? 'home_active' : icons[i]}${selected && i > 0 ? '_selected' : ''}.svg',
                                        width: 24,
                                        height: 24),
                                    if (i == 2 && app.cartItems.isNotEmpty)
                                      Positioned(
                                          top: -4,
                                          right: -8,
                                          child: Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 16),
                                              height: 16,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFE45353),
                                                  borderRadius:
                                                      BorderRadius.circular(999),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color:
                                                            Color(0x66E45353),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2))
                                                  ]),
                                              child: Text(
                                                  '${app.cartItems.length}',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white)))),
                                  ])),
                          const SizedBox(height: 3),
                          Text(labels[i],
                              style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: -.2,
                                  height: 1.1,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: color)),
                        ])),
              ));
            })),
          ))),
    ]));
  }
}
