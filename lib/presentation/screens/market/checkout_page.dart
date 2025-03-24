import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_confirmation_page.dart';
import 'add_card_page.dart';
import 'mobile_money_page.dart';
import 'bank_transfer_page.dart';
import 'receipt_page.dart';
import '../../utils/bottom_nav.dart';
import 'package:jaclean/blocs/market/checkout_bloc.dart';
import 'cart_provider.dart';
import 'package:intl/intl.dart'; 

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  String _paymentMethod = "card";
  String _shippingMethod = "dhl";
  bool _isCardAdded = false;
  bool _isMobileMoneyAdded = false;
  bool _isBankTransferAdded = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    context.read<CheckoutBloc>().add(LoadCartItems());
  }

  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _addressController.text = prefs.getString('shippingAddress') ?? '';
    });
  }

  Future<void> _saveAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shippingAddress', _addressController.text);
  }

  void _placeOrder(double total) {
    if (_formKey.currentState!.validate()) {
      if (_paymentMethod == "card" && !_isCardAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add your card details')),
        );
        return;
      }
      if (_paymentMethod == "mobile_money" && !_isMobileMoneyAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add your mobile money details')),
        );
        return;
      }
      if (_paymentMethod == "bank_transfer" && !_isBankTransferAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add your bank transfer details')),
        );
        return;
      }
      final now = DateTime.now();
      final date = DateFormat('MMM dd, yyyy').format(now);
      final time = DateFormat('hh:mm a').format(now);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
            refNumber: "0014112022",
            date: date,
            time: time,
            paymentMethod: _paymentMethod,
            amount: total, // Pass the correct total amount
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Checkout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoaded) {
              double total = state.total;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Shipping Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
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
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _addressController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter address",
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your address';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {
                                            _saveAddress();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
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
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.credit_card),
                                        title: const Text("Credit or Debit card"),
                                        trailing: Radio(
                                          value: "card",
                                          groupValue: _paymentMethod,
                                          onChanged: (value) async {
                                            setState(() {
                                              _paymentMethod = value.toString();
                                            });
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const AddCardPage()),
                                            );
                                            if (result == true) {
                                              setState(() {
                                                _isCardAdded = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.mobile_friendly),
                                        title: const Text("Mobile Money"),
                                        trailing: Radio(
                                          value: "mobile_money",
                                          groupValue: _paymentMethod,
                                          onChanged: (value) async {
                                            setState(() {
                                              _paymentMethod = value.toString();
                                            });
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => MobileMoneyPage(amount: total)),
                                            );
                                            if (result == true) {
                                              setState(() {
                                                _isMobileMoneyAdded = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.account_balance),
                                        title: const Text("Bank Transfer"),
                                        trailing: Radio(
                                          value: "bank_transfer",
                                          groupValue: _paymentMethod,
                                          onChanged: (value) async {
                                            setState(() {
                                              _paymentMethod = value.toString();
                                            });
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const BankTransferPage()),
                                            );
                                            if (result == true) {
                                              setState(() {
                                                _isBankTransferAdded = true;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Shipping method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
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
                                    children: [
                                      ListTile(
                                        leading: Radio(
                                          value: "dhl",
                                          groupValue: _shippingMethod,
                                          onChanged: (value) {
                                            setState(() {
                                              _shippingMethod = value.toString();
                                            });
                                          },
                                        ),
                                        title: const Text("DHL"),
                                        subtitle: const Text("Estimated delivery date: 6 days"),
                                      ),
                                      ListTile(
                                        leading: Radio(
                                          value: "inpost",
                                          groupValue: _shippingMethod,
                                          onChanged: (value) {
                                            setState(() {
                                              _shippingMethod = value.toString();
                                            });
                                          },
                                        ),
                                        title: const Text("Inpost"),
                                        subtitle: const Text("Estimated delivery date: 4 days"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Please note that all orders are typically processed within 1-2 business days. Once your order has been processed and shipped, you will receive a confirmation email with tracking information.",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              const Spacer(),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                                  ),
                                  onPressed: () => _placeOrder(total),
                                  child: const Text("Place an order", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: 2, // Assuming the Market tab is at index 2
      //   onItemTapped: (index) {
      //     Navigator.pushReplacementNamed(context, [
      //       '/home',
      //       '/service',
      //       '/market',
      //       '/profile',
      //       '/reviews',
      //     ][index]);
      //   },
      // ),
    );
  }
}