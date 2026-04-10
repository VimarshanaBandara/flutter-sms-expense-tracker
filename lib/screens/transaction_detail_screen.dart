import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactions = ref.watch(transactionProvider);
    final transaction = allTransactions.firstWhere(
      (t) => t.id == transactionId,
    );

    final isExpense = transaction.type == TransactionType.expense;
    final amountColour = isExpense ? AppColors.expense : AppColors.income;
    final formattedAmount =
        'LKR ${NumberFormat('#,##0.00').format(transaction.amount)}';
    final formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
    ).format(transaction.dateTime);
    final formattedTime = DateFormat('hh:mm:ss a').format(transaction.dateTime);

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero amount card
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: isExpense
                      ? AppColors.expenseTint
                      : AppColors.incomeTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isExpense
                        ? AppColors.expenseBorder
                        : AppColors.incomeBorder,
                  ),
                ),
                child: Column(
                  children: [
                    // Category emoji gives an instant visual cue.
                    Text(
                      transaction.category.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formattedAmount,
                      style: AppTextStyles.detailAmountHero(amountColour),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      transaction.type.displayName,
                      style: AppTextStyles.detailTypeLabel(amountColour),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Transaction metadata rows
            _SectionTitle('Transaction Info'),
            _DetailRow(
              icon: Icons.store,
              label: 'Merchant',
              value: transaction.merchant,
            ),
            _DetailRow(
              icon: Icons.credit_card,
              label: 'Account',
              value: transaction.accountReference,
            ),
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: formattedDate,
            ),
            _DetailRow(
              icon: Icons.access_time,
              label: 'Time',
              value: formattedTime,
            ),

            const SizedBox(height: 24),

            // Category selector
            _SectionTitle('Category'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<TransactionCategory>(
                value: transaction.category,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (selectedCategory) {
                  if (selectedCategory != null) {
                    ref
                        .read(transactionProvider.notifier)
                        .updateCategory(transactionId, selectedCategory);
                  }
                },
                items: TransactionCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(category.displayName),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Raw SMS text
            _SectionTitle('Raw SMS Message'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.rawMessage,
                style: AppTextStyles.rawSmsBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helper widgets
// ---------------------------------------------------------------------------

// Small uppercase section heading used between groups of detail rows.
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionTitle);
  }
}

// A single labelled row showing an icon, a label, and a value.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryIcon),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.detailLabel),
              Text(value, style: AppTextStyles.detailValue),
            ],
          ),
        ],
      ),
    );
  }
}
