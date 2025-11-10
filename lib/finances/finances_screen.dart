import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'finances_provider.dart';
import '../payments/payments_screen.dart';

class FinancesScreen extends ConsumerStatefulWidget {
  static const name = 'finances';
  const FinancesScreen({super.key});

  @override
  ConsumerState<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends ConsumerState<FinancesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(financesProvider.notifier).loadAll();
    });
  }

  void _addRequest(BuildContext context) {
    final titleCtrl = TextEditingController();
    final fromCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("New Payment Request"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
              TextField(controller: fromCtrl, decoration: const InputDecoration(labelText: "From")),
              TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              final from = fromCtrl.text.trim();
              final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
              if (title.isNotEmpty && from.isNotEmpty && amount > 0) {
                await ref.read(financesProvider.notifier).addRequest(title, from, amount);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addSharedAccount(BuildContext context) {
    final nameCtrl = TextEditingController();
    final membersCtrl = TextEditingController();
    final expectedCtrl = TextEditingController();
    final myAmountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("New Shared Account"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Account Name")),
              TextField(controller: membersCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Number of Members (2-4)")),
              TextField(controller: expectedCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Expected Total Amount")),
              TextField(controller: myAmountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Your Contribution Now")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final members = int.tryParse(membersCtrl.text.trim()) ?? 2;
              final expected = int.tryParse(expectedCtrl.text.trim()) ?? 0;
              final myAmount = int.tryParse(myAmountCtrl.text.trim()) ?? 0;
              if (name.isNotEmpty && members >= 2 && members <= 4) {
                await ref.read(financesProvider.notifier).addSharedAccount(
                      name: name,
                      members: members,
                      expected: expected,
                      contributed: myAmount,
                    );
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addContribution(BuildContext context, int id) {
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
            onPressed: () async {
              final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
              if (amount > 0) {
                await ref.read(financesProvider.notifier).addContribution(id, amount);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _payRequest(BuildContext context, Map<String, dynamic> request) async {
    final result = await context.pushNamed(PaymentsScreen.name);
    if (result == true) {
      final id = request["id"];
      if (id != null) {
        await ref.read(financesProvider.notifier).markAsPaid(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final finances = ref.watch(financesProvider);
    final requests = finances.requests;
    final sharedAccounts = finances.sharedAccounts;

    final total = requests.fold<int>(0, (sum, r) => sum + (r["amount"] as int? ?? 0));
    final paid = requests.where((r) => r["status"] == "Paid").fold<int>(0, (sum, r) => sum + (r["amount"] as int? ?? 0));
    final progress = total == 0 ? 0.0 : paid / total;

    final unpaidRequests = requests.where((r) => r["status"] == "Unpaid").toList();
    final paidRequests = requests.where((r) => r["status"] == "Paid").toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Finances")),
      body: finances.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(financesProvider.notifier).loadAll();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text("Total Spent", style: TextStyle(color: Colors.grey)),
                            Text("\$$total", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text("You Paid", style: TextStyle(color: Colors.grey)),
                            Text("\$$paid", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ]),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(value: progress, minHeight: 8, color: Colors.orange, backgroundColor: Colors.grey[300]),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Payment Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => _addRequest(context), icon: const Icon(Icons.add_circle, color: Colors.orange)),
                    ]),
                    if (requests.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("No payment requests yet.", style: TextStyle(color: Colors.grey)),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (unpaidRequests.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Unpaid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            ...unpaidRequests.map((r) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.red.withOpacity(0.1),
                                      child: const Icon(Icons.close, color: Colors.red),
                                    ),
                                    title: Text(r["title"] ?? ''),
                                    subtitle: Text("Requested by ${r["from"] ?? ''}"),
                                    trailing: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 80, maxHeight: 36),
                                      child: ElevatedButton(
                                        onPressed: () => _payRequest(context, r),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                        child: const Text("Pay"),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                          if (paidRequests.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Paid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            ...paidRequests.map((r) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.green.withOpacity(0.1),
                                      child: const Icon(Icons.check, color: Colors.green),
                                    ),
                                    title: Text(r["title"] ?? ''),
                                    subtitle: Text("Requested by ${r["from"] ?? ''}"),
                                    trailing: const Text("Paid", style: TextStyle(color: Colors.green)),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    const SizedBox(height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Split Expenses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => _addSharedAccount(context), icon: const Icon(Icons.add_circle, color: Colors.orange)),
                    ]),
                    if (sharedAccounts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("No shared accounts yet.", style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...sharedAccounts.asMap().entries.map((e) {
                        final acc = e.value;
                        final expected = acc["expected"] as int? ?? 0;
                        final contributed = acc["contributed"] as int? ?? 0;
                        final progress = expected == 0 ? 0.0 : contributed / expected;

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.group, color: Colors.orange),
                            title: Text(acc["name"] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${acc["members"] ?? 0} members | Expected: \$$expected"),
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
                                Text("\$$contributed", style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () => _addContribution(context, acc["id"])),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}
