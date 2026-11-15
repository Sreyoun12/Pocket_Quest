import 'account.dart';

class SavingGoal extends Account {
  double targetAmount;

  SavingGoal({
    required super.id,
    required super.name,
    required super.amount,
    required super.createdAt,
    required super.updatedAt,
    required this.targetAmount,
  });
}