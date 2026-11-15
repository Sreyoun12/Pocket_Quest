import '../model/budget_challenge.dart';
import '../model/transaction.dart';

class BudgetChallengeService {
  final List<BudgetChallenge> challenges = [];
  final List<Transaction> transactions = [];

  //add challenge
  void addChallenge ({ required BudgetChallenge challenge}){
    if (_findCategoryOrNull(challenge.id) != null){
      throw Exception( "Challenge already exists");
    }
    if (challenge.name.trim().isEmpty) {
      throw Exception('Challenge name cannot be empty');
    }
    if (challenge.spendLimit <= 0) {
      throw Exception('Spend limit must be greater than zero');
    }
    if (challenge.endDate.isBefore(challenge.startDate)) {
      throw Exception('End date cannot be before start date');
    }
    challenges.add(challenge);
  }

  //remove challenge
  void removeChallenge ({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Challenge not found");
    }
    challenges.remove(challenge);
  }

  //update challenge
  void updateChallenge({required BudgetChallenge newChallenge}){
    BudgetChallenge? challenge = _findCategoryOrNull(newChallenge.id);
    if (challenge == null){
      throw Exception ("Challenge not found");
    }
    if (newChallenge.name.trim().isEmpty){
      throw Exception("Challenge name cannot be empty");
    }
    if (newChallenge.spendLimit <= 0){
      throw Exception("Spend limit must be greate than zero");
    }
    if (newChallenge.endDate.isBefore(newChallenge.startDate)){
      throw Exception("Invalid challenge dates");
    }
    challenge.name = newChallenge.name;
    challenge.spendLimit = newChallenge.spendLimit;
    challenge.categoryId = newChallenge.categoryId;
    challenge.startDate = newChallenge.startDate;
    challenge.endDate = newChallenge.endDate;
    challenge.status = newChallenge.status;
    challenge.transactionId = newChallenge.transactionId;
  }

  //view all challenges
  List<BudgetChallenge> vieewAllChallenges(){
    return challenges;
  }

  //get challenge period
  Duration getChallengePeriod({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Challenge not found");
    }
    return challenge.endDate.difference(challenge.startDate);
  }

  //get challenge amount
  double getChallengeAmount ({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Chalenge not found");
    }
    return challenge.spendLimit;
  }

  //calculate spending
  double getSpendAmount({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Challenge not found");
    }
    double total = 0;
    for (Transaction t in transactions){
      if (t.transactionType == TransactionType.expense &&
          t.category.id == challenge.categoryId.id &&
          !t.createdAt.isBefore(challenge.startDate) &&
          !t.createdAt.isAfter(challenge.endDate)) {
            total += t.amount;
          }
    }
    return total;
  }

  //calculate remaining budget
  double getRemainingBudget ({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Challenge not found");
      }

    double spending = getSpendAmount(challengeId: challengeId);
    return challenge.spendLimit -spending;
  }

  //get challenge status
  ChallengeStatus getStatus({required int challengeId}){
    BudgetChallenge? challenge = _findCategoryOrNull(challengeId);
    if (challenge == null){
      throw Exception("Challenge not found");
    }

    double spending = getSpendAmount(challengeId: challengeId);
    if (spending > challenge.spendLimit){
      challenge.status = ChallengeStatus.overspending;
    } else if (DateTime.now().isAfter(challenge.endDate)){
      challenge.status = ChallengeStatus.completed;
    } else {
      challenge.status = ChallengeStatus.underspending;
    }
    return challenge.status;
  }

  //helper method - Find challenge
  BudgetChallenge? _findCategoryOrNull(int challengeId){
    for (BudgetChallenge c in challenges){
      if (c.id == challenges){
        return c;
      }
    }
    return null;
  }
}