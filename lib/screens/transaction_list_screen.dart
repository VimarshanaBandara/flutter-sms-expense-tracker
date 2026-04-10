import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_card.dart';
import '../widgets/summary_card.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final totalExpense = ref.watch(totalExpenseProvider);
    final totalIncome = ref.watch(totalIncomeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SMS Finance Tracker')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions found.'))
          : Column(
              children: [
                SummaryCard(
                  totalExpense: totalExpense,
                  totalIncome: totalIncome,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Transactions (${transactions.length})',
                        style: AppTextStyles.sectionCount,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionCard(
                        transaction: transaction,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionDetailScreen(
                                transactionId: transaction.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
