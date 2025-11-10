import 'package:intl/intl.dart'; //importar la librería intl

class Event {   //tiene todos los campos que el backend necesita
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime startAt;
  final DateTime endAt;
  final int capacity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? enrolled; // lo agrega findAll en el backend

  Event({  //permite crear un objeto Event fácilmente, asegurando que los campos importantes sean obligatorios
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.startAt,
    required this.endAt,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
    this.enrolled,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      capacity: json['capacity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      enrolled: json['enrolled'] as int?, // puede venir null en POST
    );
  }

  /// Body que mandás al backend en POST /events
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'capacity': capacity,
    };
  }

  String get formattedDate { // Esto formatea las fechas en un texto legible, como:
    final formatter = DateFormat('EEE, MMM d • h:mm a');
    return '${formatter.format(startAt)} - ${formatter.format(endAt)}';
  }

  String get daysLeftLabel { // Calcula cuántos días faltan para que empiece el evento y devuelve un texto listo para mostrar:
    final diff = startAt.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Finished';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'In 1 day';
    return 'In $diff days';
  }

 // URL que se usará en el feed
  String get displayImageUrl =>
      imageUrl?.isNotEmpty == true
          ? imageUrl!
          : 'https://picsum.photos/seed/$id/600/300';
}
