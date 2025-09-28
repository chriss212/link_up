import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  static const name = 'payments';
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(decoration: const InputDecoration(labelText: "First Name")),
              TextFormField(decoration: const InputDecoration(labelText: "Last Name")),
              TextFormField(decoration: const InputDecoration(labelText: "Email")),
              TextFormField(decoration: const InputDecoration(labelText: "Phone")),
              TextFormField(
                controller: cardCtrl,
                decoration: const InputDecoration(labelText: "Card Number"),
                validator: (v) => v != null && v.length == 16 ? null : "Invalid card",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment successful ✅")),
                    );
                    Navigator.pop(context, true); 
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
