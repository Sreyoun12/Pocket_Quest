abstract class Account {
  final int id;
  String name;
  double amount;
  final DateTime createdAt;
  DateTime updatedAt;

  Account({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });
}