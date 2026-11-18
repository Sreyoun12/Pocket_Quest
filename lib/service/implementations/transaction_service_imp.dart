import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/service/implementations/wallet_service_imp.dart';
import 'package:pocket_quest/service/interfaces/transaction_service.dart';

class TransactionServiceImp implements TransactionServiceInterface {
  List<Transaction> transactions = [];
  WalletServiceImp wallets = WalletServiceImp();

  @override
  void addTransaction({required Transaction transaction}) {
    //--------------------------------------------------------------------------
    // 2. Check if amount is valid
    // 3. Destination must not exist for non tranfer
    // 4. Destination required for transfer
    // 5. source must different from destination
    // 6. check if balance(of source acc) is enough for transaction
    // 7. update balance
    // 8. add transaction to list
    //--------------------------------------------------------------------------

    //1
    if (transaction.id != null &&
        findTransactionOrNull(transactionId: transaction.id!) != null) {
      throw Exception('Transaction already exist!');
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
    if (transaction.transactionType == TransactionType.tranfer &&
        transaction.source == transaction.destination) {
      throw Exception('Source and destination cannot be the same!');
    }

    //6
    if (transaction.transactionType != TransactionType.income &&
        transaction.source.balance < transaction.amount) {
      throw Exception('Balance is insufficient!');
    }

    //7
    if (transaction.transactionType == TransactionType.income) {
      transaction.source.deposit(transaction.amount);
    } else if (transaction.transactionType == TransactionType.expense) {
      transaction.source.withdraw(transaction.amount);
    } else if (transaction.transactionType == TransactionType.tranfer) {
      transaction.source.withdraw(transaction.amount);
      transaction.destination!.deposit(transaction.amount);
    }

    //8
    transactions.add(transaction);
  }

  @override
  void removeTransaction({required int transactionId}) {
    //--------------------------------------------------------------------------------
    // 1. The transaction must exist.
    // 2. It must have been created within the last 24 hours (use createdAt, not date).
    // 3. The reversal must be possible: removing income needs enough wallet balance,
    //    and removing a transfer needs the goal to still exist with enough balance.
    // 4. Reverse the effect, then remove it.
    //--------------------------------------------------------------------------------

    //1
    final Transaction? t = findTransactionOrNull(transactionId: transactionId);
    if (t == null) {
      throw Exception('Transaction does not exist!');
    }

    //2
    final Duration age = DateTime.now().difference(t.createdAt);
    if (age > const Duration(hours: 24)) {
      throw Exception('Transaction can only be removed within 24 hours!');
    }
    //3
    if (t.transactionType == TransactionType.income) {
      // Reversing income takes the money back out of the source wallet.
      if (t.source.balance < t.amount) {
        throw Exception('Balance is insufficient to reverse this income!');
      }
    } else if (t.transactionType == TransactionType.tranfer) {
      // Reversing a transfer takes the money back from the destination.
      if (t.destination == null) {
        throw Exception('Destination no longer exists!');
      }
      if (t.destination!.balance < t.amount) {
        throw Exception('Destination balance is insufficient to reverse!');
      }
    }
    //4
    if (t.transactionType == TransactionType.income) {
      t.source.withdraw(t.amount);
    } else if (t.transactionType == TransactionType.expense) {
      t.source.deposit(t.amount);
    } else if (t.transactionType == TransactionType.tranfer) {
      t.destination!.withdraw(t.amount);
      t.source.deposit(t.amount);
    }
    transactions.remove(t);
  }

  @override
  void updateTransaction({required Transaction transaction}) {
    //--------------------------------------------------------------------------
    // 1. The transaction must exist.
    // 2. category must not be empty.
    // 3. date must not be in the future.
    // 4. amount, transactionType and goalId must match the stored values.
    //    Throw if they differ, rather than silently ignoring them.
    // 5. Update
    //--------------------------------------------------------------------------

    //1
    if (transaction.id == null) {
      throw Exception('Transaction does not exist!');
    }
    Transaction? transactionOrNull = findTransactionOrNull(
      transactionId: transaction.id!,
    );
    if (transactionOrNull == null) {
      throw Exception('Transaction does not exist!');
    }

    //2
    if (transaction.category.name.trim().isEmpty) {
      throw Exception('Category cannot be empty!');
    }

    //3
    if (transaction.createdAt.isAfter(DateTime.now())) {
      throw Exception('Date cannot be in the future!');
    }

    //4
    if (transaction.amount != transactionOrNull.amount) {
      throw Exception('Amount cannot be changed!');
    }
    if (transaction.transactionType != transactionOrNull.transactionType) {
      throw Exception('Transaction type cannot be changed!');
    }
    if (transaction.destination != transactionOrNull.destination) {
      throw Exception('Destination cannot be changed!');
    }

    //5
    transactionOrNull.updatedAt = DateTime.now();
    transactionOrNull.category = transaction.category;
  }

  @override
  List<Transaction> viewAllTransactions() {
    return transactions;
  }

  @override
  double getTotalIncome() {
    double totalIncome = 0;
    for (Transaction t in transactions) {
      if (t.transactionType == TransactionType.income) {
        totalIncome += t.amount;
      }
    }
    return totalIncome;
  }

  @override
  double getTotalExpense() {
    double totalExpense = 0;
    for (Transaction t in transactions) {
      if (t.transactionType == TransactionType.expense) {
        totalExpense += t.amount;
      }
    }
    return totalExpense;
  }

  @override
  Map<String, double> getExpenseTotalsByCategory({
    required String categoryName,
  }) {
    final String key = categoryName.trim().toLowerCase();
    if (key.isEmpty) {
      throw Exception('Category cannot be empty!');
    }

    double expenseBycategory = 0;
    for (Transaction t in transactions) {
      if (t.transactionType == TransactionType.expense &&
          t.category.name.trim().toLowerCase() == key) {
        expenseBycategory += t.amount;
      }
    }
    return {categoryName: expenseBycategory};
  }

  @override
  List<Transaction> viewExpensesByCategory({required String categoryName}) {
    //--------------------------------------------------------------------------
    // 1. category must not be empty.
    // 2. No match returns an empty list. Compare with trim().toLowerCase().
    //--------------------------------------------------------------------------
    final String key = categoryName.trim().toLowerCase();

    // 1.
    if (key.isEmpty) {
      throw Exception('Category cannot be empty!');
    }
    //2
    return transactions
        .where(
          (t) =>
              t.transactionType == TransactionType.expense &&
              t.category.name.trim().toLowerCase() == key,
        )
        .toList();
  }

  //helper
  @override
  Transaction? findTransactionOrNull({required int transactionId}) {
    for (Transaction t in transactions) {
      if (t.id == transactionId) {
        return t;
      }
    }
    return null;
  }
}
