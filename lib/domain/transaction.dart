class Transaction {
  final DateTime date;
  final String category;
  final double amount;
  final bool isIncome;

  Transaction({
    required this.date,
    required this.category,
    required this.amount,
    required this.isIncome,
  });
}
