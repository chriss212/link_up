import 'package:flutter/material.dart';
import 'payments_service.dart';

class PaymentsScreen extends StatelessWidget {
  static const name = 'payments';
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final service = PaymentsService();

    final firstNameCtrl = TextEditingController();
    final lastNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cardCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameCtrl,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: lastNameCtrl,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: cardCtrl,
                decoration: const InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (v.length != 16) return "Invalid card";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    try {
                      final success = await service.makePayment(
                        firstName: firstNameCtrl.text,
                        lastName: lastNameCtrl.text,
                        email: emailCtrl.text,
                        phone: phoneCtrl.text,
                        cardNumber: cardCtrl.text,
                        amount: 100,
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Payment successful ✅")),
                        );
                        Navigator.pop(context, true); // 👈 importante
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Payment failed ❌, please try again.")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }
                },
                child: const Text("Pay Now"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}