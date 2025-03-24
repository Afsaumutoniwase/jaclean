import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaclean/presentation/theme/app_colors.dart';
import 'package:jaclean/presentation/widgets/custom_elevated_btn.dart';
import 'package:jaclean/blocs/profile/manage_bank_account_bloc.dart';

class ManageBankAccountScreen extends StatefulWidget {
  const ManageBankAccountScreen({super.key});

  @override
  State<ManageBankAccountScreen> createState() => _ManageBankAccountScreenState();
}

class _ManageBankAccountScreenState extends State<ManageBankAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageBankAccountBloc()..add(FetchBankDetails()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Bank Account"),
        ),
        body: BlocConsumer<ManageBankAccountBloc, ManageBankAccountState>(
          listener: (context, state) {
            if (state is ManageBankAccountSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bank details updated successfully')),
              );
              Navigator.pop(context);
            } else if (state is ManageBankAccountFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is ManageBankAccountLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ManageBankAccountLoaded) {
              _accountNameController.text = state.accountName;
              _accountNumberController.text = state.accountNumber;
              _bankNameController.text = state.bankName;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Withdrawal Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This is where funds you have saved will be sent to when you initiate a withdrawal. Funds are sent instantly.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _accountNameController,
                          decoration: const InputDecoration(
                            labelText: "Account Name",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _accountNumberController,
                          decoration: const InputDecoration(
                            labelText: "Account Number",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _bankNameController,
                          decoration: const InputDecoration(
                            labelText: "Bank Name",
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedBtn(
                          onPressed: () {
                            context.read<ManageBankAccountBloc>().add(
                              UpdateBankDetails(
                                accountName: _accountNameController.text.trim(),
                                accountNumber: _accountNumberController.text.trim(),
                                bankName: _bankNameController.text.trim(),
                              ),
                            );
                          },
                          text: "Update Bank",
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedBtn(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "Close",
                          // color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}