import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/presentation/widgets/custom_history_tile.dart';
import 'package:jaclean/blocs/profile/profile_account_bloc.dart';
import 'package:jaclean/blocs/profile/withdrawal_history_bloc.dart';

class WithdrawalHistory extends StatelessWidget {
  WithdrawalHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawalHistoryBloc()..add(FetchWithdrawalHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Withdrawal History"),
        ),
        body: BlocBuilder<WithdrawalHistoryBloc, WithdrawalHistoryState>(
          builder: (context, state) {
            if (state is WithdrawalHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WithdrawalHistoryError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is WithdrawalHistoryLoaded) {
              final withdrawalData = state.withdrawals;

              if (withdrawalData.isEmpty) {
                return const Center(child: Text("No withdrawal history found."));
              }

              return ListView.builder(
                itemCount: withdrawalData.length,
                itemBuilder: (context, index) {
                  var data = withdrawalData[index];

                  DateTime dateTime = (data['timestamp'] as Timestamp).toDate();
                  String transactionDate = ""
                      "${dateTime.day}-"
                      "${dateTime.month}-"
                      "${dateTime.year} "
                      "${dateTime.hour}:"
                      "${dateTime.minute}";

                  return CustomHistoryTile(
                    title: data['title'] ?? 'Withdrawal',
                    date: transactionDate,
                    amount: data['amount']?.toString() ?? '0.0',
                    status: data['status'] ?? 'pending',
                  );
                },
              );
            }

            return const Center(child: Text("No user signed in."));
          },
        ),
      ),
    );
  }
}