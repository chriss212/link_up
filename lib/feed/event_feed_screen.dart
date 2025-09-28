import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/events/new_events_screen.dart';
import 'package:link_up/events/events_details_screen.dart';

class EventFeedScreen extends StatefulWidget {
  static const name = 'feed';
  const EventFeedScreen({super.key});

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

// ===== Modelo + datos quemados =====
class _EventItem {
  final String title;
  final String fecha;
  final String DiasFaltantes;
  final String foto_evento;

  const _EventItem({
    required this.title,
    required this.fecha,
    required this.DiasFaltantes,
    required this.foto_evento,
  });
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  final List<_EventItem> _events = const [
    _EventItem(
      title: 'ROATAN 2026',
      fecha: 'Saturday, July 20',
      DiasFaltantes: 'In 3 days',
      foto_evento: 'assets/images/roatan1.jpeg',
    ),
    _EventItem(
      title: 'Fiesta Camila',
      fecha: 'Saturday, Aug 3',
      DiasFaltantes: 'In 2 weeks',
      foto_evento: 'assets/images/fiesta.jpeg',
    ),
    _EventItem(
      title: 'Hiking',
      fecha: 'Saturday, Aug 10',
      DiasFaltantes: 'In 3 weeks',
      foto_evento: 'assets/images/salidita.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.search_outlined, color: Colors.grey.shade600),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _events.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _EventCard(item: _events[index]),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => context.goNamed(NewEventScreen.name),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 2,
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }
}

// ===== Tarjeta de evento =====
class _EventCard extends StatelessWidget {
  final _EventItem item;
  const _EventCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navegar al detalle (opcional)
          context.goNamed(
            EventDetailsScreen.name,
            pathParameters: {
              'title': item.title,
              'date': item.fecha,
              'location': 'TBD',
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                item.foto_evento,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        item.fecha,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.DiasFaltantes,
                    style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatares de ejemplo
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _circle('A', Colors.blue.shade400),
                          Positioned(left: 20, child: _circle('B', Colors.green.shade400)),
                          Positioned(left: 40, child: _circle('+3', Colors.purple.shade400, fontSize: 10)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(String text, Color color, {double fontSize = 12}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
