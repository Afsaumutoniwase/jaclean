import 'package:flutter/material.dart';
import 'package:jaclean/presentation/theme/app_colors.dart';
import 'package:jaclean/presentation/theme/app_border_radius.dart';
class CustomContainer extends StatelessWidget {

  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(


      padding: const EdgeInsets.symmetric(vertical:10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: AppBorderRadius.medium ,
        border: Border.all(color: AppColors.backgroundGrey ),

      ),

      child: child,
    );
  }
}
