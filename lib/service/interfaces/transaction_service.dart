import 'package:pocket_quest/model/transaction.dart';

abstract interface class TransactionServiceInterface {
  //CRUD logic
  void addTransaction({required Transaction transaction});
  void removeTransaction();
  void updateTransaction();
  List<Transaction?> viewAllTransaction();

  // Helper
  Transaction? findTransactionOrNull(int? transactionId);
  void updateBalance(Transaction transaction);
}
