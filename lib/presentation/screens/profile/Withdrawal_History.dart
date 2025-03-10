import 'package:flutter/material.dart';

import '../../widgets/custom_history_tile.dart';


class WithdrawalHistory extends StatelessWidget {
  WithdrawalHistory({super.key});

  final List<Map<String, String?>> withdrawalData = [
    {
      'title': 'Withdrawal',
      'date': '2023-01-01 16:20',
      'amount': '₦50,000',
      'status': 'pending',
    },
    {
      'title': 'Withdrawal',
      'date': '2023-01-02 10:10',
      'amount': '₦30,000',
      // No status for this one
    },
    {
      'title': 'Withdrawal',
      'date': '2023-01-03 14:30',
      'amount': '₦20,000',
      'status': 'failed',
    },
    {
      'title': 'Withdrawal',
      'date': '2023-01-03 14:39',
      'amount': '₦2,000',
      'status': 'completed',
    },
    {
      'title': 'Withdrawal',
      'date': '2023-01-03 14:55',
      'amount': '₦22,000',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.builder(
        itemCount: withdrawalData.length,
          itemBuilder: (context, index){
          var data  = withdrawalData[index];

          return CustomHistoryTile(
              title: data['title']!,
              date: data['date']!,
              amount: data['amount']!,
              status: data['status'],
          );
          })
    );
  }
}
