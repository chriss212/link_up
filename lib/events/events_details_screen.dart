import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/events/providers/event_provider.dart';
import 'package:link_up/feed/event_feed_screen.dart';
import 'package:link_up/events/models/event.dart';

class EventDetailsScreen extends ConsumerWidget {
  static const name = 'event-details';

  final Event event; // 👈 modelo del backend

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👇 ESTE es el estado del itinerary/expenses/notes
    final eventState = ref.watch(eventProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Event Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.inputDecorationTheme.fillColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            context.goNamed(EventFeedScreen.name);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title, // 👈 antes 'title'
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.formattedDate, // 👈 usa getter del modelo
                        // si no lo tienes aún, puedes usar:
                        // event.date.toLocal().toString().split(' ')[0],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Capacity: ${event.capacity} • Enrolled: ${event.enrolled ?? 0}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Itinerary Section
            _buildSection(
              context: context,
              theme: theme,
              colorScheme: colorScheme,
              title: "Itinerary",
              icon: Icons.schedule_outlined,
              items: eventState.itinerary, // 👈 viene del provider
              itemBuilder: (item, index) => _buildItineraryItem(
                context,
                theme,
                colorScheme,
                item,
                index,
                ref,
              ),
              onAdd: () => _showAddItineraryDialog(context, ref),
            ),

            const SizedBox(height: 16),

            // Expenses Section
            _buildSection(
              context: context,
              theme: theme,
              colorScheme: colorScheme,
              title: "Expenses",
              icon: Icons.attach_money_outlined,
              items: eventState.expenses,
              itemBuilder: (item, index) => _buildExpenseItem(
                context,
                theme,
                colorScheme,
                item,
                index,
                ref,
              ),
              onAdd: () => _showAddExpenseDialog(context, ref),
            ),

            const SizedBox(height: 16),

            // Notes Section
            _buildSection(
              context: context,
              theme: theme,
              colorScheme: colorScheme,
              title: "Shared Notes & Docs",
              icon: Icons.note_outlined,
              items: eventState.notes.map((n) => {"note": n}).toList(),
              itemBuilder: (item, index) => _buildNoteItem(
                context,
                theme,
                colorScheme,
                item["note"] as String,
                index,
                ref,
              ),
              onAdd: () => _showAddNoteDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required IconData icon,
    required List items,
    required Widget Function(dynamic, int) itemBuilder,
    required VoidCallback onAdd,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: Icon(icon, color: colorScheme.primary),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          children: [
            if (items.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  "No items yet",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              )
            else
              ...items.asMap().entries.map((e) => itemBuilder(e.value, e.key)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text("Add ${title.split(' ')[0]}"),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                onPressed: onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> item,
    int index,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["time"],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item["description"].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item["description"],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () =>
                ref.read(eventProvider.notifier).removeItinerary(index),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> item,
    int index,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item["title"],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            "\$${item["amount"]}",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () =>
                ref.read(eventProvider.notifier).removeExpense(index),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    String note,
    int index,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () =>
                ref.read(eventProvider.notifier).removeNote(index),
          ),
        ],
      ),
    );
  }

  void _showAddItineraryDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activityCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: theme.inputDecorationTheme.fillColor,
        title: Text(
          "New Itinerary Item",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityCtrl,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: "Activity",
                labelStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6)),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeCtrl,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: "Time",
                labelStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6)),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6)),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
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
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: theme.inputDecorationTheme.fillColor,
        title: Text(
          "New Expense",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6)),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6)),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                final amount =
                    int.tryParse(amountCtrl.text.trim()) ?? 0;
                ref.read(eventProvider.notifier).addExpense(
                      titleCtrl.text.trim(),
                      amount,
                    );
              }
              Navigator.of(dctx).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: theme.inputDecorationTheme.fillColor,
        title: Text(
          "New Note",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: "Note",
            labelStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6)),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (noteCtrl.text.isNotEmpty) {
                ref
                    .read(eventProvider.notifier)
                    .addNote(noteCtrl.text.trim());
              }
              Navigator.of(dctx).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
