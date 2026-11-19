import 'package:pocket_quest/model/saving_goal.dart';
import 'package:pocket_quest/service/interfaces/saving_goal_service.dart';

class SavingGoalServiceImp implements SavingGoalServiceInterface {
  List<SavingGoal> goals = [];

  @override
  void addSavingGoal({required SavingGoal goal}) {
    //--------------------------------------------------------------------------
    // 1. A goal with the same id must not already exist.
    // 2. name must not be empty (use trim()).
    // 3. targetAmount must be greater than 0.
    // 4. currentAmount >= 0 and not above the target
    // 5. the end date must be after the start date.
    // 6. add to list
    //--------------------------------------------------------------------------

    //1
    SavingGoal? savingGoalOrnull = getSavingGoalOrNull(goalId: goal.id);
    if (savingGoalOrnull != null) {
      throw Exception('This goal ${goal.id} has already exist');
    }
    //2
    if (goal.name.trim().isEmpty) {
      throw Exception('Goal name must not empty');
    }
    //3
    if (goal.targetAmount <= 0) {
      throw Exception('Target Amount must be greater than 0');
    }
    //4
    if (goal.balance < 0 || goal.balance > goal.targetAmount) {
      throw Exception(
        'Current amount cannot be less than 0 or bigger than target amount',
      );
    }
    //5
    if (!goal.endDate.isAfter(goal.startDate)) {
      throw Exception('Start date cannot be later than End date!');
    }
    //6
    goals.add(goal);
  }

  @override
  void updateSavingGoal({required SavingGoal goal}) {
    //--------------------------------------------------------------------------
    // 1. The goal with that id must exist.
    // 2. name must not be empty (use trim()).
    // 3. check if target is valid
    // 4. don’t allow editing a goal that is already completed.
    // 5. check if new date is valid
    // 6. target amount cannot be less than current balance
    // 7. update
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrnull = getSavingGoalOrNull(goalId: goal.id);
    if (goalOrnull == null) {
      throw Exception('This goal ${goal.id} does not exist!');
    }
    //2
    if (goal.name.trim().isEmpty) {
      throw Exception('Name must not be empty!');
    }
    //3
    if (goal.targetAmount <= 0) {
      throw Exception('Target amount must bigger than 0!');
    }
    //4
    if (getGoalStatus(goalId: goal.id!) == GoalStatus.complete) {
      throw Exception('This goal already complete cannot update!');
    }
    //5
    if (!goal.endDate.isAfter(goal.startDate)) {
      throw Exception('Start date cannot be later than End date!');
    }
    //6
    if (goal.targetAmount < goalOrnull.balance) {
      throw Exception('Target amount cannot be less than current balance!');
    }
    //7
    goalOrnull.name = goal.name;
    goalOrnull.targetAmount = goal.targetAmount;
    goalOrnull.startDate = goal.startDate;
    goalOrnull.endDate = goal.endDate;
  }

  @override
  void removeSavingGoal({required int goalId}) {
    //--------------------------------------------------------------------------
    // 1. The goal with that goalId must exist.
    // 2. remove goal
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrnull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrnull == null) {
      throw Exception('Goal must exist in order to delete!');
    }
    //2
    goals.remove(goalOrnull);
  }

  @override
  List<SavingGoal> viewAllSavingGoal() {
    // view saving goal
    return List.unmodifiable(goals);
  }

  @override
  double getCurrentbalance({required int goalId}) {
    //--------------------------------------------------------------------------
    // 1. The goal must exist.
    // 2. get current balance
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrNull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrNull == null) {
      throw Exception('Cannot get balance because goal does not exist!');
    }
    //2
    return goalOrNull.balance;
  }

  @override
  GoalStatus getGoalStatus({required int goalId}) {
    //--------------------------------------------------------------------------
    // 1. The goal must exist.
    // 2. goalStatus: completed if currentAmount >= targetAmount,
    //    overdue if the end date has passed and it isn’t completed,
    //    otherwise in progress.
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrNull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrNull == null) {
      throw Exception('Goal Must exist!');
    }
    //2
    if (goalOrNull.balance >= goalOrNull.targetAmount) {
      return GoalStatus.complete;
    }
    if (!DateTime.now().isAfter(goalOrNull.endDate)) {
      return GoalStatus.progress;
    }
    return GoalStatus.overdue;
  }

  @override
  Duration getGoalPeriod({required int goalId}) {
    //--------------------------------------------------------------------------
    // 1. The goal must exist
    // 2. the end date must be after the start date.
    //--------------------------------------------------------------------------
    SavingGoal? goalOrNull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrNull == null) {
      throw Exception('Goal Must exist!');
    }

    //2
    if (!goalOrNull.endDate.isAfter(goalOrNull.startDate)) {
      throw Exception('Start date cannot be later than End date!');
    }

    return goalOrNull.endDate.difference(goalOrNull.startDate);
  }

  @override
  void deposit({required int goalId, required double amount}) {
    //--------------------------------------------------------------------------
    // 1. check if goal exist
    // 2. check if amount is valid
    // 3. amount must not exceed what goal need
    // 4. Goal must not complete yet
    // 5. update goal pocket
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrNull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrNull == null) {
      throw Exception('This goal $goalId does not exist!');
    }
    //2
    if (amount <= 0) {
      throw Exception('The deposit amount is not valid!');
    }
    //3
    if (getGoalStatus(goalId: goalId) == GoalStatus.complete) {
      throw Exception('Goal has already complete, cannot add more balance');
    }
    //4
    if (amount > goalOrNull.targetAmount - goalOrNull.balance) {
      throw Exception('Input amount must not be more than what goal need!');
    }
    //5
    goalOrNull.balance += amount;
  }

  @override
  void withdraw({required int goalId, required double amount}) {
    //--------------------------------------------------------------------------
    // 1. Check if goal exist
    // 2. Input amount must be less than current balance
    // 3. update balance
    //--------------------------------------------------------------------------

    //1
    SavingGoal? goalOrnull = getSavingGoalOrNull(goalId: goalId);
    if (goalOrnull == null) {
      throw Exception('Goal does not exist!');
    }
    //2
    if (amount <= 0) {
      throw Exception('Amount is not valid!');
    }
    //3
    if (goalOrnull.balance < amount) {
      throw Exception('Not enough balance to withraw!');
    }
    //4
    goalOrnull.balance -= amount;
  }

  // Helper
  @override
  SavingGoal? getSavingGoalOrNull({required int? goalId}) {
    for (SavingGoal s in goals) {
      if (s.id == goalId) {
        return s;
      }
    }
    return null;
  }
}
