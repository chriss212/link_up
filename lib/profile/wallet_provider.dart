import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletNotifier extends Notifier<double> {
  @override
  double build() {
    return 0.0; // estado inicial
  }

  void addMoney(double amount) {
    state += amount;
  }

  void reset() {
    state = 0.0;
  }
}

final walletProvider = NotifierProvider<WalletNotifier, double>(
  WalletNotifier.new,
);
