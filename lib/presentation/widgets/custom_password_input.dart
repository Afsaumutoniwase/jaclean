import 'package:flutter/material.dart';


class CustomPasswordInput extends StatelessWidget {
  final String hintText;
  const CustomPasswordInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
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
