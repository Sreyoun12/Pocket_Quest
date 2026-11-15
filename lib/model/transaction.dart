import 'category.dart';
import 'account.dart';

enum TransactionType { income, tranfer, expense }

class Transaction {
  final int id;
  double amount;
  final TransactionType transactionType;
  Category category;
  Account? source;
  Account? destination;
  final DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.category,
    this.source,
    this.destination,
    required this.createdAt,
    required this.updatedAt,
  });
}