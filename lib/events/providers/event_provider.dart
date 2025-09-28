import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventState {
  final List<Map<String, dynamic>> itinerary;
  final List<Map<String, dynamic>> expenses;
  final List<String> notes;

  EventState({
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

class EventNotifier extends StateNotifier<EventState> {
  EventNotifier()
      : super(EventState(
          itinerary: [
            {
              "title": "Motocross",
              "time": "10:00 AM - 1:00 PM",
              "description": "Ride at the beach dunes with the group"
            },
            {
              "title": "Dinner",
              "time": "7:00 PM - 9:00 PM",
              "description": "Seafood dinner at local restaurant"
            },
          ],
          expenses: [
            {"title": "Hotel", "amount": 200},
            {"title": "Motocross rental", "amount": 150},
          ],
          notes: [
            "Bring sunscreen and water.",
            "Book return flight before Friday.",
          ],
        ));

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
    state = EventState(itinerary: [], expenses: [], notes: []);
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, EventState>(
  (ref) => EventNotifier(),
);
