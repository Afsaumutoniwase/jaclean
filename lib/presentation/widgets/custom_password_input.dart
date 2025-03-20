import 'package:flutter/material.dart';

class CustomPasswordInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller; // Optional controller

  const CustomPasswordInput({
    Key? key,
    required this.hintText,
    this.controller, // Make controller optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller, // Use the optional controller
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: hintText,
        ),
      ),
    );
  }
}
