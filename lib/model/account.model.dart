class Account {
  final int? id;
  final String accName;
  final double currentAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    this.id,
    required this.accName,
    this.currentAmount= 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
