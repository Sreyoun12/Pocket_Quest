import 'category.dart';
import 'transaction.dart';

enum ChallengeStatus { completed, overspending, underspending }

class BudgetChallenge {
  final int? id;
  String name;
  double spendLimit;
  Category categoryId;
  DateTime startDate;
  DateTime endDate;
  ChallengeStatus status;

  BudgetChallenge({
    this.id,
    required this.name,
    required this.spendLimit,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
