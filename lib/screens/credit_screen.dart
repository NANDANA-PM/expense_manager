import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/formatters.dart';

/// UI-only screen following the Figma "Credit" page.
/// Saved lists are kept in memory (not persisted) - see README known issues.
class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _SavedItem {
  final String name;
  final String plan;
  final DateTime date;
  _SavedItem(this.name, this.plan, this.date);
}

class _CreditScreenState extends State<CreditScreen> {
  static const _creditTypes = ['Subscriptions', 'Loan', 'Bill'];
  static const _plans = ['Monthly', 'Yearly', 'One-Time'];

  final _formKey = GlobalKey<FormState>();
  final _toCtrl = TextEditingController();
  String _type = 'Subscriptions';
  String _plan = 'Monthly';
  DateTime _date = DateTime.now();
  final List<_SavedItem> _saved = [];

  @override
  void dispose() {
    _toCtrl.dispose();
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saved.insert(0, _SavedItem(_toCtrl.text.trim(), _plan, _date));
      _toCtrl.clear();
    });
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(t,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      );

  @override
  Widget build(BuildContext context) {
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
                ElevatedButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Saved Lists',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (_saved.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('Nothing saved yet',
                    style: TextStyle(color: AppColors.textGrey)),
              ),
            )
          else
            ..._saved.map(
              (s) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(s.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text('Due ${friendlyDate(s.date)}',
                    style: const TextStyle(fontSize: 10)),
                trailing: Text(s.plan,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textGrey)),
              ),
            ),
        ],
      ),
    );
  }
}