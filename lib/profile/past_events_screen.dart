import 'package:flutter/material.dart';

class PastEventsScreen extends StatelessWidget {
  static const name = 'past-events';
  const PastEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pastEvents = [
      {"place": "Cuscatancingo 🇸🇻", "date": "March 12, 2023"},
      {"place": "Bora Bora 🏝️", "date": "Aug 5, 2023"},
      {"place": "Sudan 🇸🇸", "date": "Jan 21, 2024"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Past Events")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: pastEvents
            .map((e) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(e["place"]!),
                    subtitle: Text(e["date"]!),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
