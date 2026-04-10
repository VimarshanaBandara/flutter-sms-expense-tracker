import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;

    final amountColour = isExpense ? AppColors.expense : AppColors.income;
    final backgroundTint = isExpense
        ? AppColors.expenseTint
        : AppColors.incomeTint;

    // Prefix the amount with a sign to make the direction obvious at a glance.
    final amountPrefix = isExpense ? '- ' : '+ ';
    final formattedAmount =
        '$amountPrefix LKR ${NumberFormat('#,##0.00').format(transaction.amount)}';
    final formattedDate = DateFormat(
      'dd MMM yyyy  hh:mm a',
    ).format(transaction.dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category emoji avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: backgroundTint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    transaction.category.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Merchant name, chips, and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Merchant name — truncated with ellipsis if too long.
                    Text(
                      transaction.merchant,
                      style: AppTextStyles.cardMerchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category and type chips shown side by side.
                    Row(
                      children: [
                        _CategoryChip(
                          label: transaction.category.displayName,
                          colour: AppColors.chipCategory,
                        ),
                        const SizedBox(width: 6),
                        _CategoryChip(
                          label: transaction.type.displayName,
                          colour: isExpense
                              ? AppColors.chipExpense
                              : AppColors.chipIncome,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Transaction date and time.
                    Text(formattedDate, style: AppTextStyles.cardDateTime),
                  ],
                ),
              ),

              // Signed amount
              Text(
                formattedAmount,
                style: AppTextStyles.cardAmount(amountColour),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill-shaped label used to display category and type on a card.
class _CategoryChip extends StatelessWidget {
  final String label;
  final MaterialColor colour;

  const _CategoryChip({required this.label, required this.colour});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colour.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colour.shade200),
      ),
      child: Text(label, style: AppTextStyles.chipLabel(colour)),
    );
  }
}
