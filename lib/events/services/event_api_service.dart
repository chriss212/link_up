import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_up/config/dio_provider.dart';
import 'package:link_up/events/models/event.dart';

class EventApiService {
  final Dio _dio;
  EventApiService(this._dio);

  /// GET /api/events
  Future<List<Event>> getEvents() async {
    final response = await _dio.get('/events');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => Event.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/events/:id
  Future<Event> getEventDetails(int id) async {
    final response = await _dio.get('/events/$id');
    return Event.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/events
  Future<Event> createEvent(Event event) async {
    final response = await _dio.post('/events', data: event.toJson());
    return Event.fromJson(response.data as Map<String, dynamic>);
  }

  /// Opcionales de join/leave
  Future<void> joinEvent(int eventId, String userId) async {
    await _dio.post('/events/$eventId/join', data: {'userId': userId});
  }

  Future<void> leaveEvent(int eventId, String userId) async {
    await _dio.post('/events/$eventId/leave', data: {'userId': userId});
  }
}

final eventApiServiceProvider = Provider<EventApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return EventApiService(dio);
});
