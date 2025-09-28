import 'package:flutter/material.dart';

class NewEventScreen extends StatelessWidget {
  const NewEventScreen({super.key});

 
  static const String name = 'new-event';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Event 🎉")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Event name (e.g. Beach Bonanza)",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Where's the party?",
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: "chill", child: Text("Chill")),
                  DropdownMenuItem(value: "party", child: Text("Party")),
                  DropdownMenuItem(value: "work", child: Text("Work")),
                ],
                onChanged: (val) {},
                decoration: const InputDecoration(
                  labelText: "Vibe Check (Category)",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: "Date"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: "Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Spill the deets! What's the plan?",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Evento creado (mock)")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 28,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Let's Go!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
