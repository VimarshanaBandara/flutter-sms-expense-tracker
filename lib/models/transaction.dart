enum TransactionType { expense, income }

enum TransactionCategory {
  transport,
  groceries,
  fuel,
  dining,
  shopping,
  utilities,
  other,
}

// ---------------------------------------------------------------------------
// Extensions — human-readable labels and emoji for enums
// ---------------------------------------------------------------------------

/// Adds display helpers to [TransactionCategory].
extension TransactionCategoryExtension on TransactionCategory {
  /// Returns a human-readable label (e.g. "Groceries").
  String get displayName {
    switch (this) {
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.groceries:
        return 'Groceries';
      case TransactionCategory.fuel:
        return 'Fuel';
      case TransactionCategory.dining:
        return 'Dining';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.utilities:
        return 'Utilities';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  /// Returns a representative emoji for use in the UI (e.g. "🛒").
  String get emoji {
    switch (this) {
      case TransactionCategory.transport:
        return '🚌';
      case TransactionCategory.groceries:
        return '🛒';
      case TransactionCategory.fuel:
        return '⛽';
      case TransactionCategory.dining:
        return '🍽️';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.utilities:
        return '💡';
      case TransactionCategory.other:
        return '📦';
    }
  }
}

/// Adds a display label to [TransactionType].
extension TransactionTypeExtension on TransactionType {
  /// Returns "Expense" or "Income".
  String get displayName =>
      this == TransactionType.expense ? 'Expense' : 'Income';
}

// ---------------------------------------------------------------------------
// Transaction model
// ---------------------------------------------------------------------------

/// Represents a single parsed bank-SMS transaction.
///
/// Instances are created by [SmsParser.parse] and stored in
/// [TransactionNotifier]. All fields are immutable; use [copyWith] to
/// produce an updated copy (e.g. when the user changes [category]).
class Transaction {
  /// Unique identifier generated at parse time (UUID v4).
  final String id;

  /// Transaction amount in LKR (e.g. 1692.00).
  final double amount;

  /// Whether this transaction is an expense or income.
  final TransactionType type;

  /// Name of the merchant or transfer source extracted from the SMS.
  final String merchant;

  /// Date and time the transaction occurred, parsed from the SMS body.
  final DateTime dateTime;

  /// Category assigned automatically by keyword matching; can be updated
  /// by the user from the detail screen.
  final TransactionCategory category;

  /// Masked account number from the SMS (e.g. "**1114").
  final String accountReference;

  /// The original, unmodified SMS string retained for reference.
  final String rawMessage;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.dateTime,
    required this.category,
    required this.accountReference,
    required this.rawMessage,
  });

  /// Returns a copy of this transaction with the specified fields replaced.
  ///
  /// Any field that is not supplied keeps its current value.
  Transaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? merchant,
    DateTime? dateTime,
    TransactionCategory? category,
    String? accountReference,
    String? rawMessage,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      merchant: merchant ?? this.merchant,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      accountReference: accountReference ?? this.accountReference,
      rawMessage: rawMessage ?? this.rawMessage,
    );
  }
}
