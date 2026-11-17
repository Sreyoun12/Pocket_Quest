abstract class Account {
  final int? id;
  String name;
  double balance;

  Account({required this.id, required this.name, this.balance = 0});
}
