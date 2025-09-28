import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const name = 'notifications';
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {"title": "New Event Created", "msg": "Trip to Mexico added"},
      {"title": "Payment Reminder", "msg": "Liam requested \$250"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: notifications
            .map((n) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(n["title"]!),
                    subtitle: Text(n["msg"]!),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
