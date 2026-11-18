import 'package:pocket_quest/model/wallet.dart';

abstract interface class WalletServiceInterface {
  //---------------------------------------------
  // This application only have one main wallet
  //---------------------------------------------
  Wallet getWallet();
  void updateWalletName({required String name});

  double getCurrentBalance();
}
