abstract class Account {
  final int? id;
  String name;
  double balance;
  final DateTime createdAt;
  DateTime updatedAt;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
