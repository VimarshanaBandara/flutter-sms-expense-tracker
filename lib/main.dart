// lib/main.dart
//
// Application entry point.
//
// Architecture overview:
//   main()
//     └── ProviderScope          (Riverpod — makes all providers available)
//           └── SmsFinanceApp   (MaterialApp configuration)
//                 └── SplashScreen  (initial screen → auto-navigates to
//                       └── TransactionListScreen)
//
// State management: flutter_riverpod (^2.4.9)
//   • Providers are declared in lib/providers/
//   • Widgets access providers via ConsumerWidget / ref.watch / ref.read

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // ProviderScope must wrap the entire widget tree so that every
    // ConsumerWidget in the app can locate its providers.
    const ProviderScope(
      child: SmsFinanceApp(),
    ),
  );
}

/// Root widget of the application.
///
/// Configures [MaterialApp] with [AppTheme.lightTheme] and sets
/// [SplashScreen] as the initial route.
class SmsFinanceApp extends StatelessWidget {
  const SmsFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
