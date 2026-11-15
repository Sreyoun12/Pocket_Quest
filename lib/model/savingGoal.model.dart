import 'package:pocket_quest/model/account.model.dart';

class SavingGoal extends Account {
  final double targetAmount;
  SavingGoal({
    super.id,
    required super.accName,
    super.currentAmount,
    required this.targetAmount,
    super.createdAt,
    super.updatedAt,
  });
}
