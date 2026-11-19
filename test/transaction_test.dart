import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/category.dart';
import 'package:pocket_quest/model/saving_goal.dart';
import 'package:pocket_quest/model/transaction.dart';
import 'package:pocket_quest/model/wallet.dart';
import 'package:pocket_quest/service/implementations/transaction_service_imp.dart';

void main() {
  test('Add new transaction', () {
    final transaction = TransactionServiceImp();

    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(name: 'Salary');
    Category c3 = Category(name: 'Trip');
    Wallet w = Wallet(name: 'My wallet', balance: 100);
    SavingGoal s1 = SavingGoal(
      name: 'For trip',
      targetAmount: 100,
      startDate: DateTime(2026, 11, 17),
      endDate: DateTime(2026, 11, 30),
    );

    Transaction t1 = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );

    Transaction t2 = Transaction(
      amount: 0,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
      name: 'Income',
    );
    Transaction t3 = Transaction(
      amount: 20,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
      destination: s1,
      name: 'Income',
    );
    Transaction t4 = Transaction(
      amount: 20,
      transactionType: TransactionType.tranfer,
      category: c2,
      source: w,
      name: 'Transfer',
    );
    Transaction t5 = Transaction(
      amount: 15,
      transactionType: TransactionType.tranfer,
      category: c3,
      source: w,
      destination: w,
      name: 'Transfer',
    );
    transaction.addTransaction(transaction: t1);

    // Check if add succesfull
    expect(transaction.transactions.first.id, 1);
    // check if category exist in transaction
    expect(transaction.transactions.first.category.name, 'food');
    // update balance
    expect(transaction.transactions.first.source.balance, 70);
    // for invalid amount
    expect(() => transaction.addTransaction(transaction: t2), throwsException);
    // destination must not exist for non tranfer
    expect(() => transaction.addTransaction(transaction: t3), throwsException);
    // destination must exist for tranfer
    expect(() => transaction.addTransaction(transaction: t4), throwsException);
    // source and destination must be different
    expect(() => transaction.addTransaction(transaction: t5), throwsException);
  });

  test('remove existing transaction', () {
    TransactionServiceImp transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(id: 2, name: 'Salary');

    Wallet w = Wallet(name: 'My wallet', balance: 100);
    SavingGoal g1 = SavingGoal(
      name: 'For trip',
      targetAmount: 100,
      startDate: DateTime(2026, 11, 17),
      endDate: DateTime(2026, 11, 30),
    );

    Transaction expense = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );
    Transaction income = Transaction(
      id: 2,
      amount: 110,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
      name: 'Income',
    );
    Transaction expense2 = Transaction(
      id: 3,
      amount: 110,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    Transaction transferTogoal = Transaction(
      id: 4,
      amount: 50,
      transactionType: TransactionType.tranfer,
      category: c2,
      source: w,
      destination: g1,
      name: 'Transfer',
    );
    Transaction transferFromGoal = Transaction(
      id: 5,
      amount: 20,
      transactionType: TransactionType.tranfer,
      category: c1,
      source: g1,
      destination: w,
      name: 'Transfer',
    );

    transaction.addTransaction(transaction: expense); //wallet:70
    transaction.addTransaction(transaction: income); //wallet:180
    transaction.addTransaction(
      transaction: transferTogoal,
    ); //wallet:130, goal:50
    transaction.addTransaction(transaction: expense2); //wallet:20
    transaction.addTransaction(
      transaction: transferFromGoal,
    ); //wallet:40, goal:30

    transaction.removeTransaction(transactionId: 1); //wallet:70

    // check if it cannot remove non existing transaction
    expect(
      () => transaction.removeTransaction(transactionId: 4),
      throwsException,
    );
    // Check if remove succesfull
    expect(transaction.transactions.length, 4);
    // check if balance is updated after remove
    expect(transaction.transactions.first.source.balance, 70);

    //check if can remove if balance is insufficient
    expect(
      () => transaction.removeTransaction(transactionId: 2),
      throwsException,
    );
    //check if it cannot remove after 24 hours
    expect(
      () => transaction.removeTransaction(transactionId: 3),
      throwsException,
    );
    // check if it cannot remove if destination balance is insufficient
    expect(
      () => transaction.removeTransaction(transactionId: 4),
      throwsException,
    );
  });

  test('Update existing transaction', () {
    TransactionServiceImp transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(id: 2, name: 'Salary');

    Wallet w = Wallet(name: 'My wallet', balance: 100);

    Transaction t1 = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );

    transaction.addTransaction(transaction: t1); //wallet:70

    // Update transaction
    Transaction updatedTransaction = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Updated Expense',
    );

    transaction.updateTransaction(transaction: updatedTransaction);

    // Check if update successful
    expect(transaction.transactions.first.amount, 30);
    // Check if category is updated after update
    expect(transaction.transactions.first.category.name, 'food');
    //chect if category name is not empty
    expect(
      () => transaction.updateTransaction(
        transaction: Transaction(
          id: 1,
          amount: 30,
          transactionType: TransactionType.expense,
          category: Category(name: ''),
          source: w,
          name: 'Updated Expense',
        ),
      ),
      throwsException,
    );
    // check if date is not in the future
    expect(
      () => transaction.updateTransaction(
        transaction: Transaction(
          id: 1,
          amount: 30,
          transactionType: TransactionType.expense,
          category: c1,
          source: w,
          name: 'Updated Expense',
          createdAt: DateTime.now().add(const Duration(days: 1)),
        ),
      ),
      throwsException,
    );
  });

  test('view all transactions', () {
    TransactionServiceImp transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Wallet w = Wallet(name: 'My wallet', balance: 100);

    Transaction t1 = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );

    transaction.addTransaction(transaction: t1);

    // Check if view all transactions returns the correct list
    expect(transaction.viewAllTransactions().length, 1);
    expect(transaction.viewAllTransactions().first.id, 1);
  });

  test('Check total income and expense', () {
    TransactionServiceImp transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(id: 2, name: 'Salary');
    Wallet w = Wallet(name: 'My wallet', balance: 100);

    Transaction income1 = Transaction(
      id: 1,
      amount: 30,
      transactionType: TransactionType.income,
      category: c1,
      source: w,
      name: 'Income',
    );
    Transaction income2 = Transaction(
      id: 2,
      amount: 50,
      transactionType: TransactionType.income,
      category: c2,
      source: w,
      name: 'Income',
    );

    Transaction expense1 = Transaction(
      id: 3,
      amount: 20,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );
    Transaction expense2 = Transaction(
      id: 4,
      amount: 10,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );

    transaction.addTransaction(transaction: income1);
    transaction.addTransaction(transaction: income2);
    transaction.addTransaction(transaction: expense1);
    transaction.addTransaction(transaction: expense2);

    // Check if total income and expense are calculated correctly
    expect(transaction.getTotalIncome(), 80);
    expect(transaction.getTotalExpense(), 30);
  });

  //get Total expense by category
  test('View and total expenses by category', () {
    TransactionServiceImp transaction = TransactionServiceImp();
    Category c1 = Category(id: 1, name: 'food');
    Category c2 = Category(id: 2, name: 'Salary');
    Category c3 = Category(id: 3, name: 'Trip');
    Wallet w = Wallet(name: 'My wallet', balance: 100);

    Transaction expense1 = Transaction(
      id: 1,
      amount: 20,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );
    Transaction expense2 = Transaction(
      id: 2,
      amount: 10,
      transactionType: TransactionType.expense,
      category: c1,
      source: w,
      name: 'Expense',
    );
    Transaction expense3 = Transaction(
      id: 3,
      amount: 15,
      transactionType: TransactionType.expense,
      category: c2,
      source: w,
      name: 'Expense',
    );
    Transaction income = Transaction(
      id: 4,
      amount: 5,
      transactionType: TransactionType.income,
      category: c1,
      source: w,
      name: 'Income',
    );

    transaction.addTransaction(transaction: expense1);
    transaction.addTransaction(transaction: expense2);
    transaction.addTransaction(transaction: expense3);
    transaction.addTransaction(transaction: income);

    expect(
      transaction
          .viewExpensesByCategory(categoryName: ' FOOD ')
          .map((t) => t.id)
          .toList(),
      [1, 2],
    );
    expect(
      transaction.viewExpensesByCategory(categoryName: 'missing'),
      isEmpty,
    );
    expect(
      () => transaction.viewExpensesByCategory(categoryName: '  '),
      throwsException,
    );
    expect(transaction.getExpenseTotalsByCategory(categoryName: 'food'), {
      'food': 30,
    });
  });
}
