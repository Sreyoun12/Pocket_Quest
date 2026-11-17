import 'package:pocket_quest/model/wallet.dart';
import 'package:pocket_quest/service/interfaces/wallet_service.dart';

class WalletServiceImp implements WalletServiceInterface {
  Wallet _mainWallet = Wallet(name: "My Wallet", balance: 0);
  @override
  Wallet getWallet() {
    //Get Wallet data
    return _mainWallet;
  }

  @override
  void updateWalletName({required String name}) {
    //-------------------------------------------
    // 1. check if input name empty
    // 2. update name
    // ------------------------------------------
    if (name.trim().isEmpty) {
      throw Exception('Name cannot be empty!');
    }
    _mainWallet.name = name.trim();
  }

  @override
  double getCurrentBalance() {
    // get current balance
    return _mainWallet.balance;
  }

  @override
  void deposit({required double amount}) {
    //---------------------------------------
    // 1. check if amount is valid
    // 2. add amount to wallet
    //---------------------------------------
    if (amount <= 0) {
      throw Exception('Amount $amount is invalid!');
    }
    _mainWallet.balance += amount;
  }

  @override
  void withdraw({required double amount}) {
    //------------------------------------------
    // 1. check if amount is valid
    // 2. check if balance is enough for withraw
    // 2. Subtract amount from wallet
    //------------------------------------------
    if (amount <= 0) {
      throw Exception('Amount $amount is invalid!');
    }
    if (_mainWallet.balance < amount) {
      throw Exception('Balance is not enought to withraw!');
    }
    _mainWallet.balance -= amount;
  }
}
