import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

/// Parses bank-SMS messages into [Transaction] objects using regex extraction
/// and keyword-based category matching.
class SmsParser {
  static final _uuid = Uuid();

  // ---------------------------------------------------------------------------
  // Category keyword map
  // ---------------------------------------------------------------------------

  // Maps each [TransactionCategory] to the merchant keywords that identify it.
  // Checked in order; the first match wins. Falls back to [other].
  static const Map<TransactionCategory, List<String>> _categoryKeywords = {
    TransactionCategory.transport: [
      'INTERCHANGE',
      'TRANSPORT',
      'BUS',
      'TRAIN',
      'TAXI',
      'UBER',
      'PICKUP',
    ],
    TransactionCategory.groceries: [
      'SUPER',
      'MARKET',
      'GROCERY',
      'KEELLS',
      'CARGILLS',
      'LAUGFS',
      'ARPICO',
      'SATHOSA',
    ],
    TransactionCategory.fuel: [
      'FUEL',
      'PETROL',
      'GAS',
      'FILLING',
      'CEYPETCO',
      'IOC',
      'FUEL MART',
    ],
    TransactionCategory.dining: [
      'RESTAURANT',
      'CAFE',
      'FOOD',
      'KFC',
      'MC',
      'BURGER',
      'PIZZA',
      'COFFEE',
      'DINE',
    ],
    TransactionCategory.shopping: [
      'SHOP',
      'STORE',
      'MALL',
      'FASHION',
      'CLOTHING',
      'BOUTIQUE',
    ],
    TransactionCategory.utilities: [
      'ELECTRIC',
      'WATER',
      'TELECOM',
      'DIALOG',
      'MOBITEL',
      'SLT',
      'CEB',
      'LECO',
    ],
  };

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Parses a single bank-SMS [rawSms] into a [Transaction].
  ///
  /// Returns `null` if no LKR amount is found (i.e. not a transaction SMS).
  static Transaction? parse(String rawSms) {
    final message = rawSms.trim();

    // Step 1 — Amount: match "LKR 1,692.00" → extract "1692.00"
    final amountMatch = RegExp(r'LKR\s*([\d,]+\.?\d*)').firstMatch(message);
    if (amountMatch == null) return null;

    final transactionAmount = double.tryParse(
      amountMatch.group(1)!.replaceAll(',', ''),
    );
    if (transactionAmount == null) return null;

    // Step 2 — Type: "debited" → expense, anything else → income
    final lowerMessage = message.toLowerCase();
    final transactionType =
        (lowerMessage.contains('debited') && !lowerMessage.contains('credited'))
        ? TransactionType.expense
        : TransactionType.income;

    // Step 3 — Account reference: match "AC **1114"
    final accountMatch = RegExp(r'AC\s*(\*+\d+)').firstMatch(message);
    final accountReference = accountMatch?.group(1) ?? 'Unknown';

    // Step 4 — Merchant: capture name between "POS at" and the terminal id
    // e.g. "POS at KEELLS SUPER - KOTTAWA 10402483" → "KEELLS SUPER - KOTTAWA"
    final merchantMatch = RegExp(
      r'(?:POS at|via POS at)\s+([A-Z][A-Z0-9\s\-&]+?)(?:\s+\d{5,})',
      caseSensitive: false,
    ).firstMatch(message);
    final merchantName =
        merchantMatch?.group(1)?.trim() ?? _fallbackMerchant(message);

    // Step 5 — Date/time: match "28/03/2026 14:19:13" (DD/MM/YYYY HH:MM:SS)
    final dateTimeMatch = RegExp(
      r'(\d{2}/\d{2}/\d{4})\s+(\d{2}:\d{2}:\d{2})',
    ).firstMatch(message);
    final transactionDateTime = _parseDateTime(dateTimeMatch);

    // Step 6 — Category: keyword lookup on the merchant name
    final category = _categorise(merchantName);

    return Transaction(
      id: _uuid.v4(),
      amount: transactionAmount,
      type: transactionType,
      merchant: merchantName,
      dateTime: transactionDateTime,
      category: category,
      accountReference: accountReference,
      rawMessage: message,
    );
  }

  /// Parses every message in [rawSmsList], silently dropping unparseable ones.
  static List<Transaction> parseAll(List<String> rawSmsList) {
    return rawSmsList.map(parse).whereType<Transaction>().toList();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Converts a regex [match] containing date (group 1) and time (group 2)
  /// into a [DateTime]. Falls back to [DateTime.now()] on any parse error.
  static DateTime _parseDateTime(RegExpMatch? match) {
    if (match == null) return DateTime.now();
    try {
      final d = match.group(1)!.split('/'); // [DD, MM, YYYY]
      final t = match.group(2)!.split(':'); // [HH, MM, SS]
      return DateTime(
        int.parse(d[2]),
        int.parse(d[1]),
        int.parse(d[0]), // date
        int.parse(t[0]),
        int.parse(t[1]),
        int.parse(t[2]), // time
      );
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Looks up the first [TransactionCategory] whose keyword list contains
  /// a substring match in [merchantName]. Defaults to [other].
  static TransactionCategory _categorise(String merchantName) {
    final upperMerchant = merchantName.toUpperCase();
    for (final entry in _categoryKeywords.entries) {
      if (entry.value.any((keyword) => upperMerchant.contains(keyword))) {
        return entry.key;
      }
    }
    return TransactionCategory.other;
  }

  /// Last-resort merchant name: the first run of consecutive uppercase words.
  static String _fallbackMerchant(String message) {
    final match = RegExp(
      r'\b([A-Z]{3,}(?:\s+[A-Z]{2,}){0,4})\b',
    ).firstMatch(message);
    return match?.group(1) ?? 'Unknown Merchant';
  }
}
