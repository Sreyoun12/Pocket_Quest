import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/category.dart';
import 'package:pocket_quest/model/saving_goal.dart';
import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/model/wallet.dart';
import 'package:pocket_quest/service/implementations/transaction_service_imp.dart';
import 'package:pocket_quest/service/interfaces/transaction_service.dart';

void main() {
  test('Add new transaction', () {
    final transaction = TransactionServiceImp();

    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(name: 'Salary');
    Category c3 = Category(name: 'Trip');
    Wallet w = Wallet(name: 'My wallet', balance: 100);
    SavingGoal s1 = SavingGoal(name: 'For trip', targetAmount: 100);

    Transaction t1 = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
    );

    Transaction t2 = Transaction(
      amount: 0,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
    );
    Transaction t3 = Transaction(
      amount: 20,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
      destination: s1,
    );
    Transaction t4 = Transaction(
      amount: 20,
      transactionType: TransactionType.tranfer,
      category: c2,
      source: w,
    );
    Transaction t5 = Transaction(
      amount: 15,
      transactionType: TransactionType.tranfer,
      category: c3,
      source: w,
      destination: w,
    );
    transaction.addTransaction(transaction: t1);

    // Check if add succesfull
    expect(transaction.transactions.first.id, 1);
    // check if category exist in transaction
    expect(transaction.transactions.first.category.name, 'food');
    // update balance
    expect(transaction.transactions.first.source.balance, 70);
    // for invalid ammount
    expect(() => transaction.addTransaction(transaction: t2), throwsException);
    // destination must not exist for non tranfer
    expect(() => transaction.addTransaction(transaction: t3), throwsException);
    // destination must exist for tranfer
    expect(() => transaction.addTransaction(transaction: t4), throwsException);
    // source and destination must be different
    expect(() => transaction.addTransaction(transaction: t5), throwsException);
  });

  test('remove exist transaction', () {});
}
