import 'account.model.dart';

class Wallet extends Account {
  Wallet({
    super.id,
    required super.accName,
    required super.currentAmount,
    super.updatedAt,
    super.createdAt,
  });
}
