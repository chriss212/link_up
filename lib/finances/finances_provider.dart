import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancesState {
  final List<Map<String, dynamic>> requests;
  final List<Map<String, dynamic>> sharedAccounts;

  FinancesState({
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

class FinancesNotifier extends StateNotifier<FinancesState> {
  FinancesNotifier()
      : super(
          FinancesState(
            requests: [
              {"title": "Dinner", "from": "Liam", "amount": 250, "status": "Unpaid"},
              {"title": "Hotel", "from": "Olivia", "amount": 1000, "status": "Paid"},
            ],
            sharedAccounts: [
              {"name": "Transportation", "members": 4, "expected": 500, "contributed": 0},
              {"name": "Activities", "members": 4, "expected": 750, "contributed": 0},
            ],
          ),
        );

  void addRequest(String title, String from, int amount) {
    final newRequest = {
      "title": title,
      "from": from,
      "amount": amount,
      "status": "Unpaid",
    };
    state = state.copyWith(requests: [...state.requests, newRequest]);
  }

  void markAsPaid(int index) {
    final updatedRequests = [...state.requests];
    updatedRequests[index]["status"] = "Paid";
    state = state.copyWith(requests: updatedRequests);
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
    final updatedAccounts = [...state.sharedAccounts];
    final current = updatedAccounts[index];

    updatedAccounts[index] = {
      ...current,
      "contributed": (current["contributed"] as int) + amount,
    };

    state = state.copyWith(sharedAccounts: updatedAccounts);
  }

  void reset() {
    state = FinancesState(requests: [], sharedAccounts: []);
  }
}

final financesProvider = StateNotifierProvider<FinancesNotifier, FinancesState>(
  (ref) => FinancesNotifier(),
);
