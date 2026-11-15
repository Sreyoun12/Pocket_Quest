import 'account.dart';

class Wallet extends Account {
  Wallet({
    super.id,
    required super.name,
    required super.balance,
    super.createdAt,
    super.updatedAt,
  });
}
