import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_elevated_btn.dart';
import '../../widgets/custom_full_elevated_btn.dart';
import '../../widgets/custom_title.dart';
import 'withdrawal_success.dart';
import '../../../main.dart'; // Import the main.dart file to access the bottom navigation bar

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String amount = "50,046.00";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdraw"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const CustomTitle(title: "Withdrawal Methods"),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Access Bank', style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 5,),
                  const Text('3399329933', style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 5,),
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
                      onPressed: (){},
                      text: "Change Bank"),
                  const SizedBox(height: 10,),
                  const Text(
                    "Amount",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter Amount",
                      prefixText: "₦ ",
                    ),
                  ),
                  const SizedBox(height:8,),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('10% (App Fee)'),
                            Text('₦0.00'),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₦0.00"
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),
                  CustomFullElevatedBtn(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WithdrawalSuccess() )
                    );
                  }, text: "Withdraw")
                ],
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: const MainBottomNavBar(), // Use the bottom navigation bar from main.dart
    );
  }
}