import 'package:expense_manager/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';

import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  static const _types = ['Expense', 'Income'];
  static const _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Salary',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _type = 'Expense';
  String? _category;
  DateTime? _date;
  bool _saving = false;

  bool get _isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    if (t != null) {
      _type = t.type;
      _titleCtrl.text = t.title;
      _amountCtrl.text = t.amount.toString();
      _category = t.category;
      _date = t.dateTime;
      _descCtrl.text = t.description ?? '';
    } else {
      _date = DateTime.now();
    }
    _dateCtrl.text = fieldDate(_date!);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateCtrl.text = fieldDate(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final desc = _descCtrl.text.trim();
    final t = TransactionModel(
      id: widget.transaction?.id,
      type: _type,
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text.trim()),
      category: _category!,
      date: _date!.toIso8601String(),
      description: desc.isEmpty ? null : desc,
    );

    final provider = context.read<TransactionProvider>();
    final ok = _isEdit ? await provider.edit(t) : await provider.add(t);

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Try again.')),
      );
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Transaction' : 'Transaction'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Color(0x14000000), blurRadius: 8),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TRANSACTION TYPE'),
                        DropdownButtonFormField<String>(
                          value: _type,
                          items: _types
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _type = v!),
                        ),
                        _label('NAME'),
                        TextFormField(
                          controller: _titleCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          decoration:
                              const InputDecoration(hintText: 'e.g. Netflix'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                        ),
                        _label('CATEGORY'),
                        DropdownButtonFormField<String>(
                          value: _category,
                          hint: const Text('Select category'),
                          items: _categories
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _category = v),
                          validator: (v) =>
                              v == null ? 'Select a category' : null,
                        ),
                        _label('AMOUNT'),
                        TextFormField(
                          controller: _amountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '₹ ',
                            suffixIcon: TextButton(
                              onPressed: _amountCtrl.clear,
                              child: const Text('Clear',
                                  style: TextStyle(fontSize: 11)),
                            ),
                          ),
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
                        TextFormField(
                          controller: _dateCtrl,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.calendar_today, size: 16),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Select a date'
                              : null,
                        ),
                        _label('DESCRIPTION (OPTIONAL)'),
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 2,
                          decoration:
                              const InputDecoration(hintText: 'Add a note'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}