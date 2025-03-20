import 'package:flutter/material.dart';

class CustomHistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String? status;
  const CustomHistoryTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    this.status
  });

  @override
  Widget build(BuildContext context) {
    
    Color statusColor = Colors.transparent;
    
    if (status == 'success'){
      statusColor = const Color(0xFF1EC77F);
    }
    
    else if (status == 'success'){
      statusColor = Colors.transparent;
    }
    else if (status == 'failed'){
      statusColor = const Color(0xFFF44336);
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],


      ),

      child:  ListTile(
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5,),
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status!,
                  style: const TextStyle(color:
                  Colors.white, fontSize: 11),
                ),
              ),

          ],
        ),
        subtitle:  Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.end,
          children: [
            Text(
              "₦$amount",
            style: const TextStyle(
            fontWeight: FontWeight.bold,
              fontSize: 16,
            ),

          )
          ],
        ),
      ),
    );
  }
}
