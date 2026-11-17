import 'account.dart';

class Wallet extends Account {
  //Since user can only have 1 wallet so id will start at1
  Wallet({super.id = 1, required super.name, required super.balance});
}
