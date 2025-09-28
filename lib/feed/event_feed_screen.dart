import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/events/new_events_screen.dart';
import '../config/theme/app_colors.dart';

class EventFeedScreen extends StatefulWidget {
  static const name = 'feed';
  const EventFeedScreen({super.key});

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  // EVENTOS CARDS (datos quemados)
  final List<_EventItem> _events = [
    _EventItem(
      title: 'ROATAN 2026',
      dateLabel: 'Saturday, July 20',
      relativeLabel: 'In 3 days',
      imageUrl: 'assets/images/roatan1.jpeg',
    ),
    _EventItem(
      title: 'fiesta Camila',
      dateLabel: 'Saturday, Aug 3',
      relativeLabel: 'In 2 weeks',
      imageUrl: 'assets/images/fiesta.jpeg',
    ),
    _EventItem(
      title: 'Hicking',
      dateLabel: 'Saturday, Aug 10',
      relativeLabel: 'In 3 weeks',
      imageUrl: 'assets/images/salidita.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
        centerTitle: true,
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textDark),
            onPressed: () {},
            tooltip: 'Search',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final e in _events) _EventTile(item: e),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(NewEventScreen.name);
        },
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.textLight,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Card contenedor de sección
  Widget _sectionCard({required Widget child}) {
    return Card(
      color: AppColors.surface,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}

class _EventItem {
  final String title;
  final String dateLabel; // fecha quemada
  final String relativeLabel; // texto quemado
  final String imageUrl;

  _EventItem({
    required this.title,
    required this.dateLabel,
    required this.relativeLabel,
    required this.imageUrl,
  });
}

/* cards */
class _EventTile extends StatelessWidget {
  final _EventItem item;
  const _EventTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        // ignore: deprecated_member_use
        side: BorderSide(color: AppColors.orange.withOpacity(0.25), width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen superior
          Image.asset(
            item.imageUrl,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event, color: AppColors.orange),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dateLabel,
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: AppColors.textDark.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'In 3 days',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
