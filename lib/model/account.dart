abstract class Account {
  final int? id;
  String name;
  double balance;

  Account({required this.id, required this.name, this.balance = 0});

  void deposit(double amount) {
    if (amount <= 0) {
      throw Exception('Amount is invalid!');
    }
    balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw Exception('Amount is invalid!');
    }
    if (balance < amount) {
      throw Exception('Balance is insufficient!');
    }
    balance -= amount;
  }
}
