import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/blocs/services/service_detail_bloc.dart';
import '../market/bank_transfer_page.dart';
import '../market/add_card_page.dart';
import '../market/mobile_money_page.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceType;

  const ServiceDetailPage({super.key, required this.serviceType});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  double _quantity = 1.0;
  DateTime? _selectedDate;
  String _selectedTime = '10:00 AM';
  String _selectedWasteType = '';
  String _paymentOption = '';
  final TextEditingController _locationController = TextEditingController(text: 'Default location');

  // Define the list of waste types
  final List<String> _wasteTypes = ['Plastic', 'Paper', 'Metal', 'Glass', 'Organic'];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = pickedTime != null ? '${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period}' : _selectedTime;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Waste Pickup Scheduled"),
          content: const Text("Your waste pickup has been successfully scheduled."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToBankTransferPage(BuildContext context, double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BankTransferPage(amount: amount)),
    );
  }

  void _navigateToAddCardPage(BuildContext context, double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCardPage(amount: amount)),
    );
  }

  void _navigateToMobileMoneyPage(BuildContext context, double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileMoneyPage(amount: amount)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Schedule a pickup';
    switch (widget.serviceType) {
      case 'recycling':
        title = 'Schedule a pickup for recyclable materials';
        break;
      case 'general':
        title = 'Request a pickup for non-recyclables';
        break;
      case 'donate':
        title = 'Donate Item';
        break;
      case 'bulk':
        title = 'Schedule a bulk waste removal';
        break;
    }

    double cost = _quantity * 2500;

    return BlocProvider(
      create: (context) => ServiceDetailBloc(),
      child: Scaffold(
        backgroundColor: Colors.white, // Set the white background for the entire page
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white, // Ensuring white background
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Waste type dropdown
                  const Text('Waste type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedWasteType.isEmpty ? null : _selectedWasteType,
                    items: _wasteTypes.map((String wasteType) {
                      return DropdownMenuItem<String>(
                        value: wasteType,
                        child: Text(wasteType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedWasteType = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text('Select waste type'),
                  ),
                  const SizedBox(height: 24),

                  // Quantity slider
                  const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Min: 1kg'),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 100.0,
                          divisions: 99,
                          value: _quantity,
                          label: '${_quantity.toStringAsFixed(1)} kg',
                          onChanged: (value) {
                            setState(() {
                              _quantity = value;
                            });
                          },
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                      const Text('Max: 100kg'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Cost: ₦${cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('${_quantity.toStringAsFixed(1)} kg * 2500 = ₦${cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 24),

                  // Pickup location
                  const Text('Pickup location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter pickup location',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.location_on, color: Colors.green),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Preferred date & time
                  const Text('Preferred date & time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select date',
                              style: TextStyle(color: _selectedDate != null ? Colors.black87 : Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate != null
                                  ? 'Time: $_selectedTime'
                                  : 'Select time',
                              style: TextStyle(color: _selectedDate != null ? Colors.black87 : Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.green),
                        onPressed: () {
                          _selectDateTime(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment options
                  const Text('Payment options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16.0,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'Cash',
                            groupValue: _paymentOption,
                            onChanged: (value) {
                              setState(() {
                                _paymentOption = value!;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Text(
                            'Cash',
                            style: TextStyle(color: _paymentOption == 'Cash' ? Colors.red : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'Transfer',
                            groupValue: _paymentOption,
                            onChanged: (value) {
                              setState(() {
                                _paymentOption = value!;
                              });
                              _navigateToBankTransferPage(context, cost);
                            },
                            activeColor: Colors.green,
                          ),
                          const Text('Transfer'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'Card',
                            groupValue: _paymentOption,
                            onChanged: (value) {
                              setState(() {
                                _paymentOption = value!;
                              });
                              _navigateToAddCardPage(context, cost);
                            },
                            activeColor: Colors.green,
                          ),
                          const Text('Card'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: 'Mobile Money',
                            groupValue: _paymentOption,
                            onChanged: (value) {
                              setState(() {
                                _paymentOption = value!;
                              });
                              _navigateToMobileMoneyPage(context, cost);
                            },
                            activeColor: Colors.green,
                          ),
                          const Text('Mobile Money'),
                        ],
                      ),
                    ],
                  ),
                  if (_paymentOption == 'Cash')
                    const Text(
                      'Once waste is picked up, our staff will receive the money onsite and a receipt will be given.',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<ServiceDetailBloc, ServiceDetailState>(
                      listener: (context, state) {
                        if (state is ServiceDetailSuccess) {
                          _showSuccessDialog(context);
                        } else if (state is ServiceDetailError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ServiceDetailLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a date and time')),
                              );
                              return;
                            }
                            context.read<ServiceDetailBloc>().add(SchedulePickup(
                              serviceType: widget.serviceType,
                              quantity: _quantity,
                              date: _selectedDate!,
                              time: _selectedTime,
                              wasteType: _selectedWasteType,
                              location: _locationController.text,
                              paymentOption: _paymentOption,
                              cost: cost,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Schedule', style: TextStyle(color: Colors.white, fontSize: 16)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}