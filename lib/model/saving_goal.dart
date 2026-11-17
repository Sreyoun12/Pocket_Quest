import 'account.dart';

enum GoalStatus { complete, overdue, progress }

class SavingGoal extends Account {
  double targetAmount;
  GoalStatus status;
  DateTime startDate;
  DateTime endDate;

  SavingGoal({
    super.id,
    required super.name,
    super.balance,
    required this.startDate,
    required this.endDate,
    this.status = GoalStatus.progress,
    required this.targetAmount,
  });
}
