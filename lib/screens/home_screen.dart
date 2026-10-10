import 'package:expense_manager/provider/transaction_provider.dart';
import 'package:expense_manager/widgets.dart/balance_card.dart';
import 'package:expense_manager/widgets.dart/empty_state.dart';
import 'package:expense_manager/widgets.dart/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../utils/app_theme.dart';
import '../utils/formatters.dart';


class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeScreen({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, p, _) {
            if (p.loading && p.transactions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final recent = p.transactions.take(5).toList();
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Good afternoon,',
                    style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                const Text('Sahal Muhammed',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                BalanceCard(
                  balance: p.balance,
                  income: p.totalIncome,
                  expense: p.totalExpense,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _statBox('DAILY AVERAGE', p.dailyAverage)),
                    const SizedBox(width: 12),
                    Expanded(child: _statBox('WEEKLY', p.weeklyExpense)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Transactions History',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    GestureDetector(
                      onTap: onSeeAll,
                      child: const Text('See all',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textGrey)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: EmptyState(),
                  )
                else
                  ...recent.map((t) => TransactionTile(transaction: t)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statBox(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 9, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(formatMoney(value),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}