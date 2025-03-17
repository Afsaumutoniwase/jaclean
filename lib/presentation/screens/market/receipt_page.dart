import 'package:flutter/material.dart';
import 'dart:math';
import 'order_confirmation_page.dart';

class ReceiptPage extends StatelessWidget {
  final String refNumber;
  final String date;
  final String time;
  final String paymentMethod;
  final double amount;

  const ReceiptPage({
    super.key,
    required this.refNumber,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.amount,
  });

  String _generateOrderNumber() {
    const prefix = 'FD';
    const length = 10;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    final orderNumber = List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
    return '$prefix$orderNumber';
  }

  @override
  Widget build(BuildContext context) {
    final orderNumber = _generateOrderNumber();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Payment Success",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 100),
              ),
              const SizedBox(height: 16),
              const Text(
                "Payment Success!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ref Number: $refNumber", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Date: $date", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Time: $time", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Payment Method: $paymentMethod", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Amount: ₦${amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationPage(orderNumber: orderNumber),
                    ),
                  );
                },
                child: const Text("Get e-Receipt", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}