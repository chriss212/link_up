import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/events/providers/event_provider.dart';
import 'package:link_up/feed/event_feed_screen.dart';

class EventDetailsScreen extends ConsumerWidget {
  static const name = 'event-details';

  final String title;
  final String date;
  final String location;

  const EventDetailsScreen({
    super.key,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed(EventFeedScreen.name); 
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Date: $date"),
            Text("Location: $location"),
            const SizedBox(height: 16),

    
            ExpansionTile(
              title: const Text("Itinerary"),
              children: [
                ...event.itinerary.asMap().entries.map((e) {
                  final i = e.key;
                  final r = e.value;
                  return ListTile(
                    title: Text("${r["title"]} (${r["time"]})"),
                    subtitle: Text(r["description"]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ref
                          .read(eventProvider.notifier)
                          .removeItinerary(i),
                    ),
                  );
                }),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Itinerary"),
                  onPressed: () => _showAddItineraryDialog(context, ref),
                )
              ],
            ),

          
            ExpansionTile(
              title: const Text("Expenses"),
              children: [
                ...event.expenses.asMap().entries.map((e) {
                  final i = e.key;
                  final r = e.value;
                  return ListTile(
                    title: Text(r["title"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("\$${r["amount"]}"),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => ref
                              .read(eventProvider.notifier)
                              .removeExpense(i),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Expense"),
                  onPressed: () => _showAddExpenseDialog(context, ref),
                )
              ],
            ),

            ExpansionTile(
              title: const Text("Shared Notes & Docs"),
              children: [
                ...event.notes.asMap().entries.map((e) {
                  final i = e.key;
                  final n = e.value;
                  return ListTile(
                    title: Text(n),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          ref.read(eventProvider.notifier).removeNote(i),
                    ),
                  );
                }),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Note"),
                  onPressed: () => _showAddNoteDialog(context, ref),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  void _showAddItineraryDialog(BuildContext context, WidgetRef ref) {
    final activityCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text("New Itinerary Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: activityCtrl,
                decoration: const InputDecoration(labelText: "Activity")),
            TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(labelText: "Time")),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (activityCtrl.text.isNotEmpty &&
                  timeCtrl.text.isNotEmpty) {
                ref.read(eventProvider.notifier).addItinerary(
                      activityCtrl.text.trim(),
                      timeCtrl.text.trim(),
                      descCtrl.text.trim(),
                    );
              }
              Navigator.of(dctx).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

 
  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text("New Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title")),
            TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
                ref
                    .read(eventProvider.notifier)
                    .addExpense(titleCtrl.text.trim(), amount);
              }
              Navigator.of(dctx).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text("New Note"),
        content: TextField(
            controller: noteCtrl,
            decoration: const InputDecoration(labelText: "Note")),
        actions: [
          TextButton(
            onPressed: () {
              if (noteCtrl.text.isNotEmpty) {
                ref.read(eventProvider.notifier).addNote(noteCtrl.text.trim());
              }
              Navigator.of(dctx).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
