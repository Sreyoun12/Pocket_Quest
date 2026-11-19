import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/saving_goal.dart';
import 'package:pocket_quest/service/implementations/saving_goal_service_imp.dart';

void main() {
  //add saving goal
  test('Add Saving Goal', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);

    //check if the goal is added
    expect(savingGoalService.viewAllSavingGoal().length, 1);
    //check if the goal is added correctly
    expect(savingGoalService.viewAllSavingGoal()[0].name, "Get a new phone");
    //check if name is not empty
    expect(
      () => savingGoalService.addSavingGoal(
        goal: SavingGoal(
          id: 2,
          name: "",
          targetAmount: 100.0,
          balance: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if target amount is greater than 0
    expect(
      () => savingGoalService.addSavingGoal(
        goal: SavingGoal(
          id: 3,
          name: "Get a new phone",
          targetAmount: 0.0,
          balance: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if current amount is not less than 0 or bigger than target amount
    expect(
      () => savingGoalService.addSavingGoal(
        goal: SavingGoal(
          id: 4,
          name: "Get a new phone",
          targetAmount: 100.0,
          balance: -1.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );
    //check if date is not in the future
    expect(
      () => savingGoalService.addSavingGoal(
        goal: SavingGoal(
          id: 5,
          name: "Get a new phone",
          targetAmount: 100.0,
          balance: 0.0,
          startDate: DateTime.now().add(Duration(days: 30)),
          endDate: DateTime.now(),
        ),
      ),
      throwsException,
    );
  });

  //update saving goal
  test('Update Saving Goal', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();

    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 200.0,
      balance: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);

    //update goal name (pass a NEW object so we don't mutate the stored one)
    savingGoalService.updateSavingGoal(
      goal: SavingGoal(
        id: 1,
        name: "Get a new laptop",
        targetAmount: 200.0,
        balance: 0.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
      ),
    );
    expect(savingGoalService.viewAllSavingGoal()[0].name, "Get a new laptop");

    //check if the goal exists before updating
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 2,
          name: "Get a new phone",
          targetAmount: 200.0,
          balance: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if name is not empty
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 1,
          name: "",
          targetAmount: 200.0,
          balance: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if target amount is greater than 0
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 1,
          name: "Get a new laptop",
          targetAmount: 0.0,
          balance: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if end date is after start date
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 1,
          name: "Get a new laptop",
          targetAmount: 200.0,
          balance: 100.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().subtract(Duration(days: 1)),
        ),
      ),
      throwsException,
    );

    //cannot edit a goal that is already completed
    goal.balance = 200.0;
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 1,
          name: "Get a new laptop",
          targetAmount: 200.0,
          balance: 200.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );

    //check if target amount is not less than current balance
    expect(
      () => savingGoalService.updateSavingGoal(
        goal: SavingGoal(
          id: 1,
          name: "Get a new laptop",
          targetAmount: 100.0,
          balance: 200.0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 30)),
        ),
      ),
      throwsException,
    );
  });

  //remove saving goal
  test('Remove Saving Goal', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);
    savingGoalService.removeSavingGoal(goalId: 1);

    //check if the goal is removed
    expect(savingGoalService.viewAllSavingGoal().length, 0);
    //check if goal exists before removing
    expect(
      () => savingGoalService.removeSavingGoal(goalId: 1),
      throwsException,
    );
  });

  //view all saving goal
  test('View All Saving Goal', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    SavingGoal goal1 = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    SavingGoal goal2 = SavingGoal(
      id: 2,
      name: "Get a new laptop",
      targetAmount: 200.0,
      balance: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal1);
    savingGoalService.addSavingGoal(goal: goal2);

    //check if the goals are added
    expect(savingGoalService.viewAllSavingGoal(), containsAll([goal1, goal2]));
  });

  //get current amount
  test('Get Current Balance', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 50.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);

    //check if the current balance is correct
    expect(savingGoalService.getCurrentbalance(goalId: 1), 50.0);
  });

  //get goal status
  test('Get Goal Status', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 50.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);

    //check if the goal status is correct
    expect(savingGoalService.getGoalStatus(goalId: 1), GoalStatus.progress);
  });

  //get goal period
  test('Get Goal Period', () {
    SavingGoalServiceImp savingGoalService = SavingGoalServiceImp();
    final startDate = DateTime.now();
    SavingGoal goal = SavingGoal(
      id: 1,
      name: "Get a new phone",
      targetAmount: 100.0,
      balance: 50.0,
      startDate: startDate,
      endDate: startDate.add(Duration(days: 30)),
    );
    savingGoalService.addSavingGoal(goal: goal);

    //check if the goal period is correct
    expect(savingGoalService.getGoalPeriod(goalId: 1), Duration(days: 30));
  });
}
