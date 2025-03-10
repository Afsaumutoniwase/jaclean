import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomToggleOnAndOff extends StatefulWidget {
  const CustomToggleOnAndOff({super.key});

  @override
  State<CustomToggleOnAndOff> createState() => _CustomToggleOnAndOffState();
}

class _CustomToggleOnAndOffState extends State<CustomToggleOnAndOff> {
  bool isOn = false;
  IconData currentIcon = Icons.toggle_off; // Initially set to toggle off

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
          // Update currentIcon based on the state of isOn
          currentIcon = isOn ? Icons.toggle_on : Icons.toggle_off;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOn ? AppColors.primaryGreen : AppColors.iconsDark,
        ),
        child: Icon(
          currentIcon, // Use the updated currentIcon
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }
}
