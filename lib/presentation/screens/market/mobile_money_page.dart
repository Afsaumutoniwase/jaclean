import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class MobileMoneyPage extends StatefulWidget {
  final double? amount;

  const MobileMoneyPage({super.key, this.amount});

  @override
  _MobileMoneyPageState createState() => _MobileMoneyPageState();
}

class _MobileMoneyPageState extends State<MobileMoneyPage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String _selectedNetwork = 'Airtel';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double total = widget.amount ?? cart.cartItems.fold(0, (sum, item) => sum + double.parse(item['price']!.replaceAll('₦', '').replaceAll(',', '')));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text(
          "Mobile Money",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Network",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedNetwork,
              items: ['Airtel', 'MTN'].map((String network) {
                return DropdownMenuItem<String>(
                  value: network,
                  child: Text(network),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNetwork = newValue!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Enter Mobile Money Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: "Mobile Money Number",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                onPressed: () {
                  _showPinDialog(context, total);
                },
                child: Text("Pay Now: ₦${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPinDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter PIN"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the PIN sent to your mobile number."),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: "PIN",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_pinController.text == "1234") {
                  Navigator.of(context).pop();
                  _showSuccessDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid PIN')),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Successful"),
          content: const Text("Your payment was successful."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}