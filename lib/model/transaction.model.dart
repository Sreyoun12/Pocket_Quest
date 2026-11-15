import 'category.model.dart';
import 'account.model.dart';

enum TransactionType { income, tranfer, expense }

class Transaction {
  final int? id;
  final double amount;
  final TransactionType type;
  final Category? category;
  final Account? source;
  final Account? destination;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    this.id,
    required this.amount,
    required this.type,
    this.category,
    this.source,
    this.destination,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
