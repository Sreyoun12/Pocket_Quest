import 'package:pocket_quest/model/saving_goal.dart';

abstract interface class SavingGoalServiceInterface {
  //crud
  void addSavingGoal({required SavingGoal goal});
  void updateSavingGoal({required SavingGoal goal});
  void removeSavingGoal({required int goalId});
  List<SavingGoal> viewAllSavingGoal();

  // get current amount
  double getCurrentbalance({required int goalId});
  //get goal status
  GoalStatus getGoalStatus({required int goalId});
  //get goal peroid
  Duration getGoalPeriod({required int goalId});

  //helper
  SavingGoal? getSavingGoalOrNull({required int goalId});
}
