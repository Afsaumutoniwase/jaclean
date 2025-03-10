import 'package:flutter/material.dart';


class CustomTitle extends StatelessWidget {

  final String title;
  const CustomTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
        textAlign: TextAlign.left,
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
        ),
      );
  }
}
