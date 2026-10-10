import 'package:expense_manager/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = transaction.isExpense ? AppColors.expense : AppColors.income;
    final sign = transaction.isExpense ? '-' : '+';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.category} • ${friendlyDate(transaction.dateTime)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Text(
            '$sign${formatMoney(transaction.amount)}',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
          if (onEdit != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete,
                  size: 18, color: AppColors.expense),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}