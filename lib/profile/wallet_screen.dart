import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  static const name = 'wallet';
  const WalletScreen({super.key});

  void _addMoney(BuildContext context, WidgetRef ref) {
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Add Money"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Amount"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text) ?? 0;

              Navigator.pop(dialogContext); 

              if (amount > 0) {
                ref.read(walletProvider.notifier).addMoney(amount);

                showDialog(
                  context: context,
                  builder: (successContext) => AlertDialog(
                    title: const Text("Success"),
                    content: Consumer(
                      builder: (_, ref, __) {
                        final balance = ref.watch(walletProvider);
                        return Text(
                          "Your transaction of \$${amount.toStringAsFixed(2)} "
                          "was completed successfully ✅\n\n"
                          "New balance: \$${balance.toStringAsFixed(2)}",
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(successContext),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Wallet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Balance: \$${balance.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addMoney(context, ref),
              child: const Text("Add Money"),
            ),
          ],
        ),
      ),
    );
  }
}
