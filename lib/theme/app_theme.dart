import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Colours
// ---------------------------------------------------------------------------

abstract class AppColors {
  //Brand / primary
  static final Color primaryDark = Colors.indigo.shade800;
  static final Color primary = Colors.indigo.shade700;
  static final Color primaryLight = Colors.indigo.shade500;
  static final Color primaryIcon = Colors.indigo.shade400;

  //Expense (red)
  static final Color expense = Colors.red.shade700;
  static final Color expenseTint = Colors.red.shade50;
  static final Color expenseBorder = Colors.red.shade200;
  static final Color expenseIndicator = Colors.redAccent.shade200;

  // ── Income (green)
  static final Color income = Colors.green.shade700;
  static final Color incomeTint = Colors.green.shade50;
  static final Color incomeBorder = Colors.green.shade200;
  static final Color incomeIndicator = Colors.greenAccent.shade400;

  // Chips
  // MaterialColor so callers can access .shade50 / .shade200 / .shade800.
  static const MaterialColor chipCategory = Colors.blueGrey;
  static const MaterialColor chipExpense = Colors.red;
  static const MaterialColor chipIncome = Colors.green;

  //Neutral / surface
  static const Color white = Colors.white;
  static const Color dividerOnDark = Colors.white24;
  static final Color inputBorder = Colors.grey.shade300;
  static final Color surfaceMuted = Colors.grey.shade100;

  //Text
  static final Color textMuted = Colors.grey.shade600;
  static final Color textHint = Colors.grey.shade500;
  static const Color textOnDark = Colors.white;
  static const Color textOnDarkMuted = Colors.white70;
  static const Color textSecondary = Colors.black54;
  static const Color textTertiary = Colors.black45;
}

// ---------------------------------------------------------------------------
// Text styles
// ---------------------------------------------------------------------------

abstract class AppTextStyles {
  static const TextStyle cardMerchantName = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  static TextStyle cardAmount(Color colour) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colour);

  static TextStyle cardDateTime = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static TextStyle chipLabel(MaterialColor colour) =>
      TextStyle(fontSize: 11, color: colour.shade800);

  static const TextStyle summaryBalance = TextStyle(
    color: AppColors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle summaryStatLabel = TextStyle(
    color: AppColors.textOnDarkMuted,
    fontSize: 13,
  );

  static const TextStyle summaryStatAmount = TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle detailAmountHero(Color colour) =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colour);

  static TextStyle detailTypeLabel(Color colour) =>
      TextStyle(fontSize: 14, color: colour, fontWeight: FontWeight.w500);

  static TextStyle sectionTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textHint,
    letterSpacing: 1,
  );

  static const TextStyle detailLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textTertiary,
  );

  static const TextStyle detailValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle rawSmsBody = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Colors.black87,
  );

  static const TextStyle sectionCount = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle splashTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static TextStyle splashTagline = TextStyle(
    fontSize: 14,
    color: AppColors.white.withValues(alpha: 0.75),
    letterSpacing: 0.3,
  );
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

/// Provides the [ThemeData] used by [MaterialApp].
abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      centerTitle: true,
      elevation: 0,
    ),
  );
}
