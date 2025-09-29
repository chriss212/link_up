import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletNotifier extends StateNotifier<double> {
  WalletNotifier() : super(0.0);

  void addMoney(double amount) {
    state += amount;
  }

  void reset() {
    state = 0.0;
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, double>((ref) {
  return WalletNotifier();
});
