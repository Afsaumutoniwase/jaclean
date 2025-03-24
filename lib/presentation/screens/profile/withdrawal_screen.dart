import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/presentation/widgets/custom_full_elevated_btn.dart';
import 'package:jaclean/presentation/widgets/custom_elevated_btn.dart';
import 'package:jaclean/presentation/widgets/custom_title.dart';
import 'withdrawal_success.dart' as screen;
import 'manage_bank_account_screen.dart';
import 'package:jaclean/blocs/profile/withdrawal_bloc.dart' as bloc;

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

  String bankName = '';
  String accountNumber = '';
  String accountName = '';

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
        appFee = amount * 0.10;
        totalAmount = amount + appFee;
      });
    } catch (e) {
      setState(() {
        appFee = 0.0;
        totalAmount = 0.0;
      });
    }
  }

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc.WithdrawalBloc()..add(bloc.FetchCurrentBalance()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Withdraw")),
        body: BlocConsumer<bloc.WithdrawalBloc, bloc.WithdrawalState>(
          listener: (context, state) {
            if (state is bloc.WithdrawalLoaded) {
              setState(() {
                currentBalance = state.currentBalance;
                bankName = state.bankName;
                accountNumber = state.accountNumber;
                accountName = state.accountName;
              });
            }

            if (state is bloc.WithdrawalSuccess) {
              setState(() {
                currentBalance = state.newBalance;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => screen.WithdrawalSuccess(
                    newBalance: state.newBalance,
                  ),
                ),
              ).then((_) {
                context.read<bloc.WithdrawalBloc>().add(bloc.FetchCurrentBalance());
              });
            } else if (state is bloc.WithdrawalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is bloc.WithdrawalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
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
                          Text(bankName, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(accountNumber, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(accountName, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          CustomElevatedBtn(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ManageBankAccountScreen(),
                                ),
                              ).then((_) {
                                context.read<bloc.WithdrawalBloc>().add(bloc.FetchCurrentBalance());
                              });
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
                            onPressed: () {
                              final amount = double.tryParse(_amountController.text.replaceAll(',', ''));
                              if (amount != null) {
                                if (totalAmount <= currentBalance) {
                                  context.read<bloc.WithdrawalBloc>().add(
                                    bloc.ProcessWithdrawal(totalAmount),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Insufficient balance')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a valid amount')),
                                );
                              }
                            },
                            text: "Withdraw",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
