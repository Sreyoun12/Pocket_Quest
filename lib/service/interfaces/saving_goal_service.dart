import 'package:pocket_quest/model/saving_goal.dart';

abstract interface class SavingGoalServiceInterface {
  //crud
  void addSavingGoal({required SavingGoal goal});
  void updateSavingGoal({required SavingGoal goal});
  void removeSavingGoal({required int goalId});
  List<SavingGoal> viewAllSavingGoal();

  // get current amount
  void getCurrentbalance({required SavingGoal goal});

  //helper
  SavingGoal? getSavingGoalOrNull();
}
