import 'category.dart';
import 'account.dart';

enum TransactionType { income, tranfer, expense }

class Transaction {
  final int? id;
  String name;
  double amount;
  final TransactionType transactionType;
  Category category;
  Account source;
  Account? destination;
  final DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    this.id,
    required this.name,
    required this.amount,
    required this.transactionType,
    required this.category,
    required this.source,
    this.destination,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
