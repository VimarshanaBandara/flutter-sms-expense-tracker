import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../parsers/sms_parser.dart';

const List<String> _sampleSmsMessages = [
  '''LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE 10500302
28/03/2026 14:19:13
To Inq Call 0112303050
Get protected - Do not Share OTP''',

  '''LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483
25/03/2026 17:46:49
To Inq Call 0112303050
Get protected - Do not Share OTP''',

  '''LKR 5,970.00 debited from AC **1114 via POS at P AND B FUEL MART 10000759
25/03/2026 18:58:40
To Inq Call 0112303050
Get protected - Do not Share OTP''',

  '''LKR 450.00 credited to AC **1111 from SALARY TRANSFER
01/04/2026 08:00:00
To Inq Call 0112303050
Get protected - Do not Share OTP''',

  '''LKR 850.00 debited from AC **1111 via POS at DIALOG TELECOM 20100199
01/04/2026 10:30:00
To Inq Call 0112303050
Get protected - Do not Share OTP''',
];

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    final parsedTransactions = SmsParser.parseAll(_sampleSmsMessages);

    parsedTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return parsedTransactions;
  }

  void updateCategory(String transactionId, TransactionCategory newCategory) {
    state = [
      for (final transaction in state)
        if (transaction.id == transactionId)
          transaction.copyWith(category: newCategory)
        else
          transaction,
    ];
  }

  void addFromSms(String rawSms) {
    final newTransaction = SmsParser.parse(rawSms);
    if (newTransaction != null) {
      // Prepend so the new transaction appears at the top of the list.
      state = [newTransaction, ...state];
    }
  }
}

// Providers

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<Transaction>>(
      TransactionNotifier.new,
    );

final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .fold(
        0.0,
        (runningTotal, transaction) => runningTotal + transaction.amount,
      );
});

final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .fold(
        0.0,
        (runningTotal, transaction) => runningTotal + transaction.amount,
      );
});
