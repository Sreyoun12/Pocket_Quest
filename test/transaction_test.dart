import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/category.dart';
import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/model/wallet.dart';
import 'package:pocket_quest/service/implementations/transaction_service_imp.dart';
import 'package:pocket_quest/service/interfaces/transaction_service.dart';

void main() {
  test('Add new transaction', () {
    final transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Wallet w = Wallet(name: 'My wallet', balance: 100);
    Transaction t1 = Transaction(
      id: 1,
      amount: 50,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
    );
    Category c2 = Category(name: 'Salary');
    Transaction t2 = Transaction(
      amount: 0,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
    );
    transaction.addTransaction(transaction: t1);

    expect(transaction.transactions.first.id, 1);
    expect(transaction.transactions.first.category.name, 'food');
    expect(() => transaction.addTransaction(transaction: t2), throwsException);
  });
  test('remove exist transaction', () {});
}
