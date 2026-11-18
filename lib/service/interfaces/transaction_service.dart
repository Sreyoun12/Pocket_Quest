import 'package:flutter/foundation.dart';
import 'package:pocket_quest/model/transaction.dart';

abstract interface class TransactionServiceInterface {
  //CRUD logic
  void addTransaction({required Transaction transaction});
  void removeTransaction({required int transactionId});
  void updateTransaction({required Transaction transaction});
  List<Transaction> viewAllTransactions();

  // Helper
  Transaction? findTransactionOrNull({required int transactionId});

  // Summary
  double getTotalIncome();
  double getTotalExpense();

  // By category (expenses)
  List<Transaction> viewExpensesByCategory({required String categoryName});
  Map<String, double> getExpenseTotalsByCategory({
    required String categoryName,
  });
}
