import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/model/category.dart';
import 'package:pocket_quest/model/budget_challenge.dart';
import 'package:pocket_quest/service/budget_challenge_service.dart';

void main() {
  late BudgetChallengeService service;
  late Category food;
  late BudgetChallenge challenge;

  setUp(() {
    service = BudgetChallengeService();

    food = Category(id: 1, name: 'Food');

    challenge = BudgetChallenge(
      id: 1,
      name: 'Save money on food',
      spendLimit: 100,
      categoryId: food,
      startDate: DateTime(2026, 11, 1),
      endDate: DateTime(2026, 11, 30),
      status: ChallengeStatus.underspending,
    );
  });

  group('Add Challenge', () {
    test('should add a challenge', () {
      service.addChallenge(challenge: challenge);

      expect(service.viewAllChallenges().length, 1);
    });

    test('should not add a duplicate challenge', () {
      service.addChallenge(challenge: challenge);

      expect(
        () => service.addChallenge(challenge: challenge),
        throwsException,
      );
    });

    test('should not add an empty name', () {
      final invalidChallenge = BudgetChallenge(
        id: 2,
        name: '',
        spendLimit: 100,
        categoryId: food,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 30),
        status: ChallengeStatus.underspending,
      );

      expect(
        () => service.addChallenge(challenge: invalidChallenge),
        throwsException,
      );
    });

    test('should not add a limit of zero', () {
      final invalidChallenge = BudgetChallenge(
        id: 2,
        name: 'Food Challenge',
        spendLimit: 0,
        categoryId: food,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 30),
        status: ChallengeStatus.underspending,
      );

      expect(
        () => service.addChallenge(challenge: invalidChallenge),
        throwsException,
      );
    });
  });

  group('Update Challenge', () {
    test('should update challenge information', () {
      service.addChallenge(challenge: challenge);

      final updatedChallenge = BudgetChallenge(
        id: 1,
        name: 'Save money for lunch',
        spendLimit: 200,
        categoryId: food,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 30),
        status: ChallengeStatus.underspending,
      );

      service.updateChallenge(newChallenge: updatedChallenge);

      expect(service.viewAllChallenges().first.name,
          'Save money for lunch');
      expect(service.getChallengeAmount(challengeId: 1), 200);
    });

    test('should not update a challenge that does not exist', () {
      expect(
        () => service.updateChallenge(newChallenge: challenge),
        throwsException,
      );
    });
  });

  group('Remove Challenge', () {
    test('should remove a challenge', () {
      service.addChallenge(challenge: challenge);
      service.removeChallenge(challengeId: 1);

      expect(service.viewAllChallenges(), isEmpty);
    });

    test('should not remove a missing challenge', () {
      expect(
        () => service.removeChallenge(challengeId: 99),
        throwsException,
      );
    });
  });

  group('Get Challenge Information', () {
    test('should return the spending limit', () {
      service.addChallenge(challenge: challenge);

      expect(service.getChallengeAmount(challengeId: 1), 100);
    });

    test('should return the challenge period', () {
      service.addChallenge(challenge: challenge);

      expect(
        service.getChallengePeriod(challengeId: 1).inDays,
        29,
      );
    });

    test('should return zero spending when there are no transactions', () {
      service.addChallenge(challenge: challenge);

      expect(service.getSpendAmount(challengeId: 1), 0);
    });

    test('should return the remaining budget', () {
      service.addChallenge(challenge: challenge);

      expect(service.getRemainingBudget(challengeId: 1), 100);
    });
  });
}
