class TransactionModel {
  final int? id;
  final String type; // 'Expense' or 'Income'
  final String title;
  final double amount;
  final String category;
  final String date; // ISO-8601 string
  final String? description;

  TransactionModel({
    this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  bool get isExpense => type == 'Expense';

  DateTime get dateTime => DateTime.parse(date);

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date,
        'description': description,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
        id: m['id'] as int?,
        type: m['type'] as String,
        title: m['title'] as String,
        amount: (m['amount'] as num).toDouble(),
        category: m['category'] as String,
        date: m['date'] as String,
        description: m['description'] as String?,
      );
}