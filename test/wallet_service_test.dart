import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/wallet.dart';
import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/service/implementations/transaction_service_imp.dart';
import 'package:pocket_quest/model/category.dart';

void main() {
  test('wallet', () {
    TransactionServiceImp transactionService = TransactionServiceImp();
    Wallet wallet = transactionService.wallets.getWallet();

    Transaction income = Transaction(
      id: 1,
      name: "Monthly income",
      amount: 100.0,
      transactionType: TransactionType.income,
      category: Category(name: "Test Category"),
      source: wallet,
    );
    transactionService.addTransaction(transaction: income);
    Transaction expense = Transaction(
      id: 2,
      name: "Monthly expense",
      amount: 50.0,
      transactionType: TransactionType.expense,
      category: Category(name: "Test Category 2"),
      source: wallet,
    );
    transactionService.addTransaction(transaction: expense);

    //get wallet
    expect(wallet.name, "My Wallet");
    //get wallet balance
    expect(transactionService.wallets.getCurrentBalance(), 50.0);
    //update wallet name
    wallet.name = "Updated Wallet";
    expect(wallet.name, "Updated Wallet");
  });
}
