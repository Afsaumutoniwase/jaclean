// import 'package:flutter/material.dart';

// class ServiceDetailPageMock extends StatelessWidget {
//   final String serviceType;

//   const ServiceDetailPageMock({Key? key, required this.serviceType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('$serviceType Service')),
//       body: SingleChildScrollView(
//         key: const Key('service_detail_scrollable'),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Dropdown for waste type
//               DropdownButtonFormField<String>(
//                 items: const [
//                   DropdownMenuItem(value: 'Plastic', child: Text('Plastic')),
//                   DropdownMenuItem(value: 'Metal', child: Text('Metal')),
//                 ],
//                 onChanged: (value) {},
//                 decoration: const InputDecoration(labelText: 'Waste Type'),
//               ),
//               const SizedBox(height: 16),

//               // Slider for quantity
//               Slider(
//                 value: 10,
//                 min: 1,
//                 max: 100,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 16),

//               // TextField for pickup location
//               TextField(
//                 decoration: const InputDecoration(labelText: 'Pickup Location'),
//               ),
//               const SizedBox(height: 16),

//               // Date picker button
//               IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () {
//                   // Simulate a date picker
//                   showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(const Duration(days: 365)),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Payment option
//               Row(
//                 children: [
//                   Radio(value: 'Cash', groupValue: 'Cash', onChanged: (value) {}),
//                   const Text('Cash'),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Schedule button
//               ElevatedButton(
//                 onPressed: () {
//                   // Directly show the success dialog
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text('Waste Pickup Scheduled'),
//                         content: const Text('Your waste pickup has been successfully scheduled.'),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             child: const Text('Done'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: const Text('Schedule'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }