import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class SmsParser {
  static final _uuid = Uuid();

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

  static Transaction? parse(String rawSms) {
    final message = rawSms.trim();

    final amountMatch = RegExp(r'LKR\s*([\d,]+\.?\d*)').firstMatch(message);
    if (amountMatch == null) return null;

    final transactionAmount = double.tryParse(
      amountMatch.group(1)!.replaceAll(',', ''),
    );
    if (transactionAmount == null) return null;

    final lowerMessage = message.toLowerCase();
    final transactionType =
        (lowerMessage.contains('debited') && !lowerMessage.contains('credited'))
        ? TransactionType.expense
        : TransactionType.income;

    final accountMatch = RegExp(r'AC\s*(\*+\d+)').firstMatch(message);
    final accountReference = accountMatch?.group(1) ?? 'Unknown';

    final merchantMatch = RegExp(
      r'(?:POS at|via POS at)\s+([A-Z][A-Z0-9\s\-&]+?)(?:\s+\d{5,})',
      caseSensitive: false,
    ).firstMatch(message);
    final merchantName =
        merchantMatch?.group(1)?.trim() ?? _fallbackMerchant(message);

    final dateTimeMatch = RegExp(
      r'(\d{2}/\d{2}/\d{4})\s+(\d{2}:\d{2}:\d{2})',
    ).firstMatch(message);
    final transactionDateTime = _parseDateTime(dateTimeMatch);

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

  static List<Transaction> parseAll(List<String> rawSmsList) {
    return rawSmsList.map(parse).whereType<Transaction>().toList();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

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

  static TransactionCategory _categorise(String merchantName) {
    final upperMerchant = merchantName.toUpperCase();
    for (final entry in _categoryKeywords.entries) {
      if (entry.value.any((keyword) => upperMerchant.contains(keyword))) {
        return entry.key;
      }
    }
    return TransactionCategory.other;
  }

  static String _fallbackMerchant(String message) {
    final match = RegExp(
      r'\b([A-Z]{3,}(?:\s+[A-Z]{2,}){0,4})\b',
    ).firstMatch(message);
    return match?.group(1) ?? 'Unknown Merchant';
  }
}
