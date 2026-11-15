enum TransactionType { income, tranfer, expense }

class Transaction {
  final int Id;
  final double amount;
  final TransactionType type;
  final Category category;
  final Acount source;
  final Acount destination;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({required this.Id, required this.amount, required this.type, required this.category, this.source, this.destination, this.createdAt, this.updatedAt})
}
