class CreditModel {
  final int? id;
  final String creditType; // Subscriptions, Loan, Bill
  final String name; // the "To" field
  final double amount;
  final String date; // ISO-8601 string (due date)
  final String planType; // Monthly, Yearly, One-Time

  CreditModel({
    this.id,
    required this.creditType,
    required this.name,
    required this.amount,
    required this.date,
    required this.planType,
  });

  DateTime get dateTime => DateTime.parse(date);

  Map<String, dynamic> toMap() => {
        'id': id,
        'credit_type': creditType,
        'name': name,
        'amount': amount,
        'date': date,
        'plan_type': planType,
      };

  factory CreditModel.fromMap(Map<String, dynamic> m) => CreditModel(
        id: m['id'] as int?,
        creditType: m['credit_type'] as String,
        name: m['name'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: m['date'] as String,
        planType: m['plan_type'] as String,
      );
}