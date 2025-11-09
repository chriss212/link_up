import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventState {
  final List<Map<String, dynamic>> itinerary;
  final List<Map<String, dynamic>> expenses;
  final List<String> notes;

  const EventState({
    this.itinerary = const [],
    this.expenses = const [],
    this.notes = const [],
  });

  EventState copyWith({
    List<Map<String, dynamic>>? itinerary,
    List<Map<String, dynamic>>? expenses,
    List<String>? notes,
  }) {
    return EventState(
      itinerary: itinerary ?? this.itinerary,
      expenses: expenses ?? this.expenses,
      notes: notes ?? this.notes,
    );
  }
}

/// Riverpod 3.x — Notifier API
class EventNotifier extends Notifier<EventState> {
  @override
  EventState build() {
    //  AHORA: estado inicial vacío
    return const EventState();
    // si querés explícito:
    // return const EventState(itinerary: [], expenses: [], notes: []);
  }

  void addItinerary(String title, String time, String description) {
    final newItem = {
      "title": title,
      "time": time,
      "description": description,
    };
    state = state.copyWith(itinerary: [...state.itinerary, newItem]);
  }

  void removeItinerary(int index) {
    final updated = [...state.itinerary]..removeAt(index);
    state = state.copyWith(itinerary: updated);
  }

  void addExpense(String title, int amount) {
    final newExpense = {"title": title, "amount": amount};
    state = state.copyWith(expenses: [...state.expenses, newExpense]);
  }

  void removeExpense(int index) {
    final updated = [...state.expenses]..removeAt(index);
    state = state.copyWith(expenses: updated);
  }

  void addNote(String note) {
    state = state.copyWith(notes: [...state.notes, note]);
  }

  void removeNote(int index) {
    final updated = [...state.notes]..removeAt(index);
    state = state.copyWith(notes: updated);
  }

  void reset() {
    state = const EventState();
    // o: state = const EventState(itinerary: [], expenses: [], notes: []);
  }
}

/// Provider (v3)
final eventProvider =
    NotifierProvider<EventNotifier, EventState>(EventNotifier.new);
