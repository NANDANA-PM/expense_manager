import 'package:expense_manager/provider/transaction_provider.dart';
import 'package:expense_manager/widgets.dart/confirm_dialog.dart';
import 'package:expense_manager/widgets.dart/empty_state.dart';
import 'package:expense_manager/widgets.dart/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';

import 'add_edit_transaction_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _delete(BuildContext context, TransactionModel t) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Delete transaction?',
      message: 'Are you sure you want to delete "${t.title}"?',
    );
    if (!ok || !context.mounted) return;
    final success = await context.read<TransactionProvider>().remove(t.id!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Transaction deleted' : 'Could not delete'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Consumer<TransactionProvider>(
        builder: (context, p, _) {
          if (p.loading && p.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (p.error != null && p.transactions.isEmpty) {
            return Center(child: Text(p.error!));
          }
          if (p.transactions.isEmpty) return const EmptyState();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: p.transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final t = p.transactions[i];
              return TransactionTile(
                transaction: t,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditTransactionScreen(transaction: t),
                  ),
                ),
                onDelete: () => _delete(context, t),
              );
            },
          );
        },
      ),
    );
  }
}