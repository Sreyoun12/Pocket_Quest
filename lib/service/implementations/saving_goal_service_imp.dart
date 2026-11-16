import 'package:pocket_quest/model/saving_goal.dart';
import 'package:pocket_quest/service/interfaces/saving_goal_service.dart';

class SavingGoalServiceImp implements SavingGoalServiceInterface {
  @override
  void addSavingGoal({required SavingGoal goal}) {
    // TODO: implement addSavingGoal
  }

  @override
  void updateSavingGoal({required SavingGoal goal}) {
    // TODO: implement updateSavingGoal
  }

  @override
  void removeSavingGoal({required int goalId}) {
    // TODO: implement removeSavingGoal
  }

  @override
  List<SavingGoal> viewAllSavingGoal() {
    // TODO: implement viewAllSavingGoal
    throw UnimplementedError();
  }

  @override
  void getCurrentbalance({required SavingGoal goal}) {
    // TODO: implement getCurrentbalance
  }

  @override
  SavingGoal? getSavingGoalOrNull() {
    // TODO: implement getSavingGoalOrNull
    throw UnimplementedError();
  }
}
