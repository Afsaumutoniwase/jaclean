import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_elevated_btn.dart';
import '../../widgets/custom_full_elevated_btn.dart';
import '../../widgets/custom_title.dart';
import 'withdrawal_success.dart';
import '../../../main.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
  double appFee = 0.0;
  double totalAmount = 0.0;
  double currentBalance = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentBalance();
    _amountController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentBalance() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            currentBalance = (doc.data()?['balance'] ?? 0.0).toDouble();
            isLoading = false;
          });
        } else {
          setState(() {
            currentBalance = 0.0;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching balance: $e')),
      );
    }
  }

  void _calculateTotal() {
    if (_amountController.text.isEmpty) {
      setState(() {
        appFee = 0.0;
        totalAmount = 0.0;
      });
      return;
    }

    try {
      double amount = double.parse(_amountController.text.replaceAll(',', ''));
      setState(() {
        appFee = amount * 0.10; // 10% app fee
        totalAmount = amount + appFee;
      });
    } catch (e) {
      // Handle invalid input
      setState(() {
        appFee = 0.0;
        totalAmount = 0.0;
      });
    }
  }

  Future<String?> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data()?['userName'] as String?;
    }
    return null;
  }

  Future<void> _processWithdrawal() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    double amount;
    try {
      amount = double.parse(_amountController.text.replaceAll(',', ''));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than zero')),
      );
      return;
    }

    if (amount > currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await processWithdrawal(amount);
      setState(() {
        isLoading = false;
      });

      // Navigate to success screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WithdrawalSuccess()),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing withdrawal: $e')),
      );
    }
  }

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CustomTitle(title: "Withdrawal Methods"),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Access Bank', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('3399329933', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  FutureBuilder<String?>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      return Text(
                        snapshot.data ?? "User",
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomElevatedBtn(
                    onPressed: () {
                      // Handle change bank functionality
                    },
                    text: "Change Bank",
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Available Balance:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₦${formatCurrency(currentBalance)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount",
                      prefixText: "₦ ",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('10% (App Fee)'),
                            Text('₦${formatCurrency(appFee)}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "TOTAL",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₦${formatCurrency(totalAmount)}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomFullElevatedBtn(
                    onPressed: _processWithdrawal,
                    text: "Withdraw",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to process the withdrawal transaction
Future<void> processWithdrawal(double withdrawalAmount) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      // Run a transaction to ensure data consistency
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the current user document
        final userSnapshot = await transaction.get(userRef);
        if (userSnapshot.exists) {
          final currentBalance = userSnapshot.data()?['balance'] ?? 0.0;
          if (currentBalance >= withdrawalAmount) {
            // Calculate the new balance
            final newBalance = currentBalance - withdrawalAmount;
            // Update the user's balance
            transaction.update(userRef, {'balance': newBalance});
            final transactionRef = FirebaseFirestore.instance.collection('withdrawals').doc();
            transaction.set(transactionRef, {
              'userId': user.uid,
              'amount': withdrawalAmount,
              'timestamp': FieldValue.serverTimestamp(),
              'status': 'success',
            });
          } else {

            final transactionRef = FirebaseFirestore.instance.collection('withdrawals').doc();
            transaction.set(transactionRef, {
              'userId': user.uid,
              'amount': withdrawalAmount,
              'timestamp': FieldValue.serverTimestamp(),
              'status': 'failed',
            });
            throw Exception('Insufficient funds');
          }
        } else {
          // If user doesn't exist, create a new document with default values
          transaction.set(userRef, {
            'userName': user.displayName ?? 'Anonymous',  // Default user name
            'balance': 0.0,  // Default balance (can be set to any starting value)
            'email': user.email ?? '',  // User's email
            'phoneNumber': user.phoneNumber ?? '',  // User's phone number
            'createdAt': FieldValue.serverTimestamp(),
          });
          throw Exception('User not found. A new user document has been created.');
        }
      });
    } catch (e) {
      // Re-throw to handle in the UI
      throw e;
    }
  } else {
    // Handle the case where the user is not authenticated
    throw Exception('No user is currently signed in');
  }
}