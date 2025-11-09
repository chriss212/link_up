import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_up/events/models/event.dart';
import 'package:link_up/events/services/event_api_service.dart';

class EventsFeedNotifier extends AsyncNotifier<List<Event>> {
  @override
  Future<List<Event>> build() async {
    final api = ref.read(eventApiServiceProvider);
    return api.getEvents();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(eventApiServiceProvider);
      return api.getEvents();
    });
  }
}

final eventsFeedProvider =
    AsyncNotifierProvider<EventsFeedNotifier, List<Event>>(
  EventsFeedNotifier.new,
);
