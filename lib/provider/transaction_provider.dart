import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/credit_model.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<TransactionModel> transactions = [];
  List<CreditModel> credits = [];
  bool loading = false;
  String? error;

  double get totalIncome => transactions
      .where((t) => !t.isExpense)
      .fold(0.0, (s, t) => s + t.amount);

  double get totalExpense => transactions
      .where((t) => t.isExpense)
      .fold(0.0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpense;

  /// Average expense per day, over the days that have expenses.
  double get dailyAverage {
    final expenses = transactions.where((t) => t.isExpense).toList();
    if (expenses.isEmpty) return 0;
    final days = expenses
        .map((t) => '${t.dateTime.year}-${t.dateTime.month}-${t.dateTime.day}')
        .toSet()
        .length;
    return totalExpense / days;
  }

  /// Total expenses in the last 7 days.
  double get weeklyExpense {
    final from = DateTime.now().subtract(const Duration(days: 7));
    return transactions
        .where((t) => t.isExpense && t.dateTime.isAfter(from))
        .fold(0.0, (s, t) => s + t.amount);
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      transactions = await _db.getAll();
      credits = await _db.getAllCredits();
      error = null;
    } catch (e) {
      error = 'Failed to load data';
    }
    loading = false;
    notifyListeners();
  }

  // Transactions
  Future<bool> add(TransactionModel t) => _run(() => _db.insert(t));
  Future<bool> edit(TransactionModel t) => _run(() => _db.update(t));
  Future<bool> remove(int id) => _run(() => _db.delete(id));

  // Credits
  Future<bool> addCredit(CreditModel c) => _run(() => _db.insertCredit(c));
  Future<bool> removeCredit(int id) => _run(() => _db.deleteCredit(id));

  Future<bool> clearAll() => _run(() => _db.deleteAll());

  Future<bool> _run(Future<dynamic> Function() action) async {
    try {
      await action();
      await load();
      return true;
    } catch (e) {
      error = 'Database error. Please try again.';
      notifyListeners();
      return false;
    }
  }
}