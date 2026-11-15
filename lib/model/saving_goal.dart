import 'account.dart';

class SavingGoal extends Account {
  double targetAmount;

  SavingGoal({
    super.id,
    required super.name,
    required super.balance,
    super.createdAt,
    super.updatedAt,
    required this.targetAmount,
  });
}
