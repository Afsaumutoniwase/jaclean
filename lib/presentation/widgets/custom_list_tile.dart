import 'package:flutter/material.dart';

import '../theme/app_colors.dart';


class CustomListTile extends StatelessWidget {
  final IconData  iconLeading;
  final String title;
  final String? subtitle;
  final IconData iconTrailing;
  final Widget? trailing;
  final double? trailingIconSize;
  final Color? tailingIconColor;
  final Widget? leading;
  final VoidCallback? onTap;
  const CustomListTile({
    super.key,

    required this.iconLeading,
    required this.title,
    required this.iconTrailing,
    this.trailingIconSize,
    this.tailingIconColor,
    this.subtitle,
    this.trailing,
    this.leading,
    this.onTap

  }
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(

      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),

        decoration: BoxDecoration(

            color: const Color(0xffd6efe3),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Icon(iconLeading, color: Color(0xff1FC776),),
      ),
      title:  Text(title,
        style:
        const TextStyle(
            color: AppColors.textDark,
            fontSize:18 ,
            fontWeight: FontWeight.w400

        )
        ,),
      subtitle: subtitle != null ? Text(subtitle!,
          style: const TextStyle(
          fontSize: 11
      ),) : null,
      trailing:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconTrailing,
            size: trailingIconSize,
            color: tailingIconColor,),


        ],
      ),
    );
  }
}
