import 'package:flutter/material.dart';

class CollaborativeDateSelector extends StatelessWidget {
  const CollaborativeDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final slots = [
      {"date": "July 14 — 9:00 - 12:00", "votes": 3},
      {"date": "July 15 — 10:00 - 18:00", "votes": 8},
      {"date": "July 16 — 14:00 - 18:00", "votes": 2},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Collaborative Date Selector",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...slots.map(
          (slot) => Card(
            child: ListTile(
              title: Text(slot["date"] as String),
              trailing: Text("${slot["votes"]} 👍"),
            ),
          ),
        ),
      ],
    );
  }
}
