import 'package:intl/intl.dart';

String formatMoney(double v) =>
    '₹${NumberFormat('#,##0.00', 'en_IN').format(v)}';

String friendlyDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('MMM dd, yyyy').format(d);
}

String fieldDate(DateTime d) => DateFormat('EEE, dd MMM yyyy').format(d);