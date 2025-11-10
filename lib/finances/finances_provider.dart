import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'finances_service.dart';

class FinancesState {
  final List<Map<String, dynamic>> requests;
  final List<Map<String, dynamic>> sharedAccounts;
  final bool isLoading;

  const FinancesState({
    this.requests = const [],
    this.sharedAccounts = const [],
    this.isLoading = false,
  });

  FinancesState copyWith({
    List<Map<String, dynamic>>? requests,
    List<Map<String, dynamic>>? sharedAccounts,
    bool? isLoading,
  }) {
    return FinancesState(
      requests: requests ?? this.requests,
      sharedAccounts: sharedAccounts ?? this.sharedAccounts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FinancesNotifier extends Notifier<FinancesState> {
  late final FinancesService _service;

  @override
  FinancesState build() {
    _service = FinancesService();
    return const FinancesState();
  }

  Future<void> loadAll() async {
    try {
      state = state.copyWith(isLoading: true);

      final reqs = await _service.getRequests();
      final accs = await _service.getAccounts();

      state = state.copyWith(
        requests: List<Map<String, dynamic>>.from(reqs),
        sharedAccounts: List<Map<String, dynamic>>.from(accs),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> addRequest(String title, String from, int amount) async {
    await _service.addRequest(title, from, amount);
    await loadAll();
  }

  Future<void> markAsPaid(int id) async {
    await _service.markAsPaid(id);
    await loadAll();
  }

  Future<void> addSharedAccount({
    required String name,
    required int members,
    required int expected,
    int contributed = 0,
  }) async {
    await _service.addAccount(name, members, expected, contributed);
    await loadAll();
  }

  Future<void> addContribution(int id, int amount) async {
    await _service.addContribution(id, amount);
    await loadAll();
  }
}

final financesProvider =
    NotifierProvider<FinancesNotifier, FinancesState>(FinancesNotifier.new);
