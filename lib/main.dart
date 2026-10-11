import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/location_permission_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const AlWadyApp(),
    ),
  );
}

class AlWadyApp extends StatelessWidget {
  const AlWadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الوادي للذبائح',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Enforce Arabic RTL Everywhere
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Consumer<AppProvider>(
        builder: (context, provider, _) {
          switch (provider.currentFlow) {
            case AppFlow.splash:
              return const SplashScreen();
            case AppFlow.onboarding:
              return const OnboardingScreen();
            case AppFlow.login:
              return const LoginScreen();
            case AppFlow.otp:
              return const OtpScreen();
            case AppFlow.profileSetup:
              return const ProfileSetupScreen();
            case AppFlow.locationPermission:
              return const LocationPermissionScreen();
            case AppFlow.main:
              return const MainNavigationScreen();
          }
        },
      ),
    );
  }
}
