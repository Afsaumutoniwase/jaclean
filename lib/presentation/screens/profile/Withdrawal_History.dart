import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_history_tile.dart';

class WithdrawalHistory extends StatelessWidget {
  WithdrawalHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is signed in, display a message
      return Scaffold(
        appBar: AppBar(
          title: const Text("Withdrawal History"),
        ),
        body: Center(
          child: Text("No user signed in."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdrawal History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('withdrawals')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final withdrawalData = snapshot.data?.docs ?? [];

          if (withdrawalData.isEmpty) {
            return Center(child: Text("No withdrawal history found."));
          }

          return ListView.builder(
            itemCount: withdrawalData.length,
            itemBuilder: (context, index) {
              var data = withdrawalData[index].data() as Map<String, dynamic>;

              DateTime dateTime = data['timestamp'].toDate();
              String tarnsaction_date = ""
                  "${dateTime.day}-"
                  "${dateTime.month}-"
                  "${dateTime.year}"
                  "  ${dateTime.hour}:"
                  "${dateTime.minute}";
              return CustomHistoryTile(
                title: data['title'] ?? 'Withdrawal',
                date: tarnsaction_date ?? 'Unknown Date',
                amount: data['amount']?.toString() ?? '0.0',
                status: data['status'] ?? 'pending',
              );
            },
          );
        },
      ),
    );
  }
}
