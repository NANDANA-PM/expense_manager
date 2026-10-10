import 'package:expense_manager/provider/transaction_provider.dart';
import 'package:expense_manager/widgets.dart/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/credit_model.dart';

import '../utils/app_theme.dart';
import '../utils/formatters.dart';


/// Credit screen from the Figma. Saved items are stored in SQLite.
class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  static const _creditTypes = ['Subscriptions', 'Loan', 'Bill'];
  static const _plans = ['Monthly', 'Yearly', 'One-Time'];

  final _formKey = GlobalKey<FormState>();
  final _toCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _type = 'Subscriptions';
  String _plan = 'Monthly';
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _toCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final ok = await context.read<TransactionProvider>().addCredit(
          CreditModel(
            creditType: _type,
            name: _toCtrl.text.trim(),
            amount: double.parse(_amountCtrl.text.trim()),
            date: _date.toIso8601String(),
            planType: _plan,
          ),
        );

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      _toCtrl.clear();
      _amountCtrl.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Try again.')),
      );
    }
  }

  Future<void> _delete(CreditModel c) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Delete saved item?',
      message: 'Are you sure you want to delete "${c.name}"?',
    );
    if (!ok || !mounted) return;
    await context.read<TransactionProvider>().removeCredit(c.id!);
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(t,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      );

  Widget _savedItem(CreditModel c) {
    final today = isToday(c.dateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: name + due date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textGrey),
                    children: [
                      TextSpan(text: today ? 'Due ' : 'Due On '),
                      TextSpan(
                        text: today ? 'Today' : shortDate(c.dateTime),
                        style: TextStyle(
                          color: today ? AppColors.expense : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right: plan + amount (always visible)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(c.planType,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey)),
              const SizedBox(height: 2),
              Text(
                formatMoney(c.amount),
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _delete(c),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.delete_outline,
                  size: 18, color: AppColors.expense),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final credits = context.watch<TransactionProvider>().credits;

    return Scaffold(
      appBar: AppBar(title: const Text('Credit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('CREDIT TYPE'),
                DropdownButtonFormField<String>(
                  value: _type,
                  items: _creditTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                ),
                _label('TO'),
                TextFormField(
                  controller: _toCtrl,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'This field is required'
                      : null,
                ),
                _label('AMOUNT'),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(prefixText: '₹ '),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    final n = double.tryParse(v.trim());
                    if (n == null) return 'Enter a valid number';
                    if (n <= 0) return 'Amount must be greater than 0';
                    return null;
                  },
                ),
                _label('DATE'),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today, size: 16)),
                    child: Text(fieldDate(_date)),
                  ),
                ),
                _label('PLAN TYPE'),
                DropdownButtonFormField<String>(
                  value: _plan,
                  items: _plans
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _plan = v!),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Saved Lists',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          if (credits.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('Nothing saved yet',
                    style: TextStyle(color: AppColors.textGrey)),
              ),
            )
          else
            for (int i = 0; i < credits.length; i++) ...[
              _savedItem(credits[i]),
              if (i != credits.length - 1) const Divider(height: 1),
            ],
          // Space so the last item isn't hidden behind the bottom bar / + button
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}