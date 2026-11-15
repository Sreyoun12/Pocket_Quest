import 'account.dart';

class Wallet extends Account {
  Wallet({
    required super.id,
    required super.name,
    required super.amount,
    required super.createdAt,
    required super.updatedAt,
  });
}