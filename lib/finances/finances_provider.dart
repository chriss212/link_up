import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancesState {
  final List<Map<String, dynamic>> requests;
  final List<Map<String, dynamic>> sharedAccounts;

  const FinancesState({
    this.requests = const [],
    this.sharedAccounts = const [],
  });

  FinancesState copyWith({
    List<Map<String, dynamic>>? requests,
    List<Map<String, dynamic>>? sharedAccounts,
  }) {
    return FinancesState(
      requests: requests ?? this.requests,
      sharedAccounts: sharedAccounts ?? this.sharedAccounts,
    );
  }
}

class FinancesNotifier extends Notifier<FinancesState> {
  @override
  FinancesState build() {
    return const FinancesState(
      requests: [
        {"title": "Dinner", "from": "Liam", "amount": 250, "status": "Unpaid"},
        {"title": "Hotel", "from": "Olivia", "amount": 1000, "status": "Paid"},
      ],
      sharedAccounts: [
        {"name": "Transportation", "members": 4, "expected": 500, "contributed": 0},
        {"name": "Activities", "members": 4, "expected": 750, "contributed": 0},
      ],
    );
  }

  void addRequest(String title, String from, int amount) {
    final newRequest = {"title": title, "from": from, "amount": amount, "status": "Unpaid"};
    state = state.copyWith(requests: [...state.requests, newRequest]);
  }

  void markAsPaid(int index) {
    final updated = [...state.requests];
    updated[index] = {...updated[index], "status": "Paid"};
    state = state.copyWith(requests: updated);
  }

  void addSharedAccount({
    required String name,
    required int members,
    required int expected,
    int contributed = 0,
  }) {
    final newAccount = {
      "name": name,
      "members": members,
      "expected": expected,
      "contributed": contributed,
    };
    state = state.copyWith(sharedAccounts: [...state.sharedAccounts, newAccount]);
  }

  void addContribution(int index, int amount) {
    final updated = [...state.sharedAccounts];
    final current = updated[index];
    updated[index] = {...current, "contributed": (current["contributed"] as int) + amount};
    state = state.copyWith(sharedAccounts: updated);
  }

  void reset() {
    state = const FinancesState(requests: [], sharedAccounts: []);
  }
}

final financesProvider =
    NotifierProvider<FinancesNotifier, FinancesState>(FinancesNotifier.new);
