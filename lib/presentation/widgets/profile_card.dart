import 'package:flutter/material.dart';

import '../theme/app_border_radius.dart';
import '../theme/app_colors.dart';
import '../widgets/circular_avater.dart';

class ProfileCard extends StatelessWidget {

  final String firstName;
  final String lastName;
  final String profilePicUrl;




  const ProfileCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color:AppColors.primaryGreen,
        borderRadius: AppBorderRadius.medium,


      ),

      child: Row(
        children: [
        const CircularAvatar(
          radius:AppBorderRadius.avatar,
          backgroundColor:AppColors.backgroundLight,
          backgroundUrl: ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLhrdK20s0iXZZGFaTC6M9tLEZi01K0GrPLw&s")
          ),
          const SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text("Hello,", style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),),

              Text(
                '$firstName $lastName',
                style:const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
