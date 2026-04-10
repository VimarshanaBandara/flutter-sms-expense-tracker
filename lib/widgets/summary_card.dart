import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final double totalExpense;
  final double totalIncome;

  const SummaryCard({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0.00');
    final netBalance = totalIncome - totalExpense;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Balance: LKR ${currencyFormatter.format(netBalance)}',
            style: AppTextStyles.summaryBalance,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FinancialStatItem(
                label: 'Income',
                formattedAmount: 'LKR ${currencyFormatter.format(totalIncome)}',
                icon: Icons.arrow_downward,
                colour: AppColors.incomeIndicator,
              ),
              // Vertical divider between the two stat items.
              Container(width: 1, height: 40, color: AppColors.dividerOnDark),
              _FinancialStatItem(
                label: 'Expenses',
                formattedAmount:
                    'LKR ${currencyFormatter.format(totalExpense)}',
                icon: Icons.arrow_upward,
                colour: AppColors.expenseIndicator,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// A small column showing a directional icon, a label, and an amount.

class _FinancialStatItem extends StatelessWidget {
  final String label;
  final String formattedAmount;
  final IconData icon;
  final Color colour;

  const _FinancialStatItem({
    required this.label,
    required this.formattedAmount,
    required this.icon,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon and label on the same row.
        Row(
          children: [
            Icon(icon, color: colour, size: 18),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.summaryStatLabel),
          ],
        ),
        const SizedBox(height: 4),

        // Formatted currency amount below the label.
        Text(formattedAmount, style: AppTextStyles.summaryStatAmount),
      ],
    );
  }
}
