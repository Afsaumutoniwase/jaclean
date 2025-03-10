import 'package:flutter/material.dart';

import '../theme/app_border_radius.dart';
import '../theme/app_colors.dart';



class CustomElevatedBtn extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  const CustomElevatedBtn({
    super.key,
    required this.onPressed,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor:AppColors.primaryGreen,
            shape: const RoundedRectangleBorder(
                borderRadius: AppBorderRadius.large
            )
        ),
        child: Text(text, style:
        const TextStyle(
          color: AppColors.textWhite,
          fontSize: 16,
          fontWeight: FontWeight.w700,

        ),

        )
    );
  }
}
