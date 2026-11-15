import 'package:pocket_quest/model/category.model.dart';

enum Status { complete, overspending, underspending }

class BudgetChallenge {
  final int? id;
  final String challengeName;
  final double spendLimit;
  final double currentSpending;
  final Category category;
  final DateTime startDate;
  final DateTime endDate;
  final Status status;

  BudgetChallenge({
    this.id,
    required this.challengeName,
    this.currentSpending = 0,
    required this.spendLimit,
    required this.category,
    required this.status,
    DateTime? startDate,
    DateTime? endDate,
  }) : startDate = DateTime.now(),
       endDate = DateTime.now();
}
