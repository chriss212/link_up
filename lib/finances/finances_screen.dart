import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'finances_provider.dart';
import '../payments/payments_screen.dart';
import 'package:go_router/go_router.dart';

class FinancesScreen extends ConsumerWidget {
  static const name = 'finances';
  const FinancesScreen({super.key});

  void _addRequest(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final fromCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("New Payment Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: fromCtrl, decoration: const InputDecoration(labelText: "From")),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final from = fromCtrl.text.trim();
              final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;

              ref.read(financesProvider.notifier).addRequest(title, from, amount);
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _addSharedAccount(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final membersCtrl = TextEditingController();
    final expectedCtrl = TextEditingController();
    final myAmountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("New Shared Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Account Name")),
            TextField(controller: membersCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Number of Members (2-4)")),
            TextField(controller: expectedCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Expected Total Amount")),
            TextField(controller: myAmountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Your Contribution Now")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final members = int.tryParse(membersCtrl.text.trim()) ?? 2;
              final expected = int.tryParse(expectedCtrl.text.trim()) ?? 0;
              final myAmount = int.tryParse(myAmountCtrl.text.trim()) ?? 0;

              if (members >= 2 && members <= 4) {
                ref.read(financesProvider.notifier).addSharedAccount(
                  name: name,
                  members: members,
                  expected: expected,
                  contributed: myAmount,
                );
              }

              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _addContribution(BuildContext context, WidgetRef ref, int index) {
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Add Contribution"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Amount"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
              if (amount > 0) {
                ref.read(financesProvider.notifier).addContribution(index, amount);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _payRequest(BuildContext context, WidgetRef ref, int i) async {
    final result = await context.pushNamed(PaymentsScreen.name);
    if (result == true) {
      ref.read(financesProvider.notifier).markAsPaid(i);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finances = ref.watch(financesProvider);
    final requests = finances.requests;
    final sharedAccounts = finances.sharedAccounts;

    final total = requests.fold<int>(0, (sum, r) => sum + (r["amount"] as int));
    final paid = requests
        .where((r) => r["status"] == "Paid")
        .fold<int>(0, (sum, r) => sum + (r["amount"] as int));
    final progress = total == 0 ? 0.0 : paid / total;

    return Scaffold(
      appBar: AppBar(title: const Text("Finances")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Spent", style: TextStyle(color: Colors.grey)),
                      Text("\$$total", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("You Paid", style: TextStyle(color: Colors.grey)),
                      Text("\$$paid", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress, minHeight: 8, color: Colors.orange, backgroundColor: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Still Due", style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: const StadiumBorder()),
                        onPressed: () {},
                        child: const Text("Settle Up", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

     
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => _addRequest(context, ref), icon: const Icon(Icons.add_circle, color: Colors.orange)),
              ],
            ),
            ...requests.asMap().entries.map((e) {
              final i = e.key;
              final r = e.value;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: r["status"] == "Unpaid" ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    child: Icon(r["status"] == "Unpaid" ? Icons.close : Icons.check, color: r["status"] == "Unpaid" ? Colors.red : Colors.green),
                  ),
                  title: Text(r["title"]),
                  subtitle: Text("Requested by ${r["from"]}"),
                  trailing: r["status"] == "Unpaid"
                      ? ElevatedButton(onPressed: () => _payRequest(context, ref, i), child: const Text("Pay"))
                      : const Text("Paid", style: TextStyle(color: Colors.green)),
                ),
              );
            }),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Split Expenses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => _addSharedAccount(context, ref), icon: const Icon(Icons.add_circle, color: Colors.orange)),
              ],
            ),
            ...sharedAccounts.asMap().entries.map((e) {
              final i = e.key;
              final acc = e.value;
              final expected = acc["expected"] as int;
              final contributed = acc["contributed"] as int;
              final progress = expected == 0 ? 0.0 : contributed / expected;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.group, color: Colors.orange),
                  title: Text(acc["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${acc["members"]} members | Expected: \$$expected"),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress > 1 ? 1 : progress,
                        minHeight: 6,
                        color: Colors.orange,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text("\$${acc["contributed"]}",
        style: const TextStyle(fontWeight: FontWeight.bold)),
    IconButton(
      icon: const Icon(Icons.add_circle, color: Colors.green),
      onPressed: () => _addContribution(context, ref, i),
    ),
  ],
),

                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
