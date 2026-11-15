import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/service/interfaces/transaction_service.dart';

class TransactionServiceImp implements TransactionServiceInterface {
  List<Transaction> transactions = [];

  @override
  void addTransaction({required Transaction transaction}) {
    // TODO: implement addTransaction
    //--------------------------------------------------------------------------
    // 1. Check if transaction already exist through id(not sure since id was auto increment so it might not duplicate)
    // 2. Check if amount is valid
    // 3. Destination must not exist for non tranfer
    // 4. Destination required for transfer
    // 5. source must different from destination
    // 6. check if balance(of source acc) is enough for transaction
    // 7. add transaction to list
    //--------------------------------------------------------------------------

    //1
    Transaction? t = findTransactionOrNull(transaction.id);
    if (t != null) {
      throw Exception('Transaction already exist! ');
    }
    //2
    if (transaction.amount <= 0) {
      throw Exception('Amount is invalid! It must be greater than 0');
    }
    //3
    if (transaction.transactionType == TransactionType.expense ||
        transaction.transactionType == TransactionType.income) {
      if (transaction.destination != null) {
        throw Exception('Destination must be null!');
      }
    }
    //4
    if (transaction.transactionType == TransactionType.tranfer) {
      if (transaction.destination == null) {
        throw Exception('Destination must exist!');
      }
    }
    //5
    if (transaction.source == transaction.destination) {
      throw Exception('Source and destination cannot be the same!');
    }
    //6
    if (transaction.source.balance < transaction.amount) {
      throw Exception('Balance is insufficent!');
    }

    //7
    transactions.add(transaction);
  }

  @override
  void removeTransaction() {
    // TODO: implement removeTransaction
  }
  @override
  void updateTransaction() {
    // TODO: implement updateTransaction
  }
  @override
  List<Transaction?> viewAllTransaction() {
    // TODO: implement viewAllTransaction
    throw UnimplementedError();
  }

  @override
  Transaction? findTransactionOrNull(int? transactionId) {
    // TODO: implement findTransactionOrNull
    for (Transaction t in transactions) {
      if (t.id == transactionId) {
        return t;
      }
    }
    return null;
    throw UnimplementedError();
  }
}
