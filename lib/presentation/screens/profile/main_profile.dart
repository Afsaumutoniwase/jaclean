import 'package:flutter/material.dart';
import 'package:jaclean/presentation/screens/profile/profile_account.dart';
import 'package:jaclean/presentation/screens/profile/withdrawal_screen.dart';

import '../../theme/app_colors.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_elevated_btn.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/profile_card.dart';
import 'Withdrawal_History.dart';
import 'change_password.dart';


class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  double balance = 50046.00;
  String fisrtName = "Simeon";
  String lastName ="Azeh";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),

      ),
     body: SingleChildScrollView(

       physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ProfileCard(
                firstName: fisrtName,
                  lastName: lastName,
                  profilePicUrl:""),

              // balance section
              const SizedBox(height: 20,),
              CustomContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Wallet Balance",
                      style: TextStyle(
                        color: AppColors.textDark ,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),

                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                        children: [
                        Text(
                          "₦ $balance",
                          style: const TextStyle(
                            color: AppColors.secondaryGreen,
                            fontSize: 24.24,

                          ),
                        ),
                        const SizedBox(width: 8,),
                        const Icon(Icons.visibility, color:AppColors.iconsDark,),
                  ]),

                    //ElevatedBtn

                        CustomElevatedBtn(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WithdrawalScreen())

                          );

                        },
                        text: "Withdraw",
                        )


                      ],

                    ),
                    const SizedBox(height: 8,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                              (context)=>WithdrawalHistory())
                        );
                      },
                      child: const Row(
                          children: [
                            Text(
                                "History",
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                ),

                            ),
                           Icon(Icons.chevron_right, color:AppColors.primaryRed, size: 16,)

                          ],
                        ),
                    )
                  ],
                )
              ),
              const SizedBox(height: 20,),
              //Action Settings
              CustomContainer(
                child:  Column(
                  children: [
                    CustomListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context) => ProfileAccount(
                                firstName:fisrtName,
                                lastName: lastName,

                            )
                        ));

                      },
                      iconLeading: Icons.person_outlined,
                      title: 'My Account',
                      subtitle: 'Make changes to your account',
                      iconTrailing: Icons.chevron_right,
                    ),
                  const CustomListTile(
                      iconLeading:Icons.person_outlined,
                      title: "Manage Banks Account",
                      subtitle: "Manage your saved account",
                      iconTrailing: Icons.chevron_right
                  ),

                    const CustomListTile(
                        subtitle: "Manage Your device security",
                        iconLeading: Icons.lock,
                        title: "Face ID & Touch ID",
                        iconTrailing: Icons.toggle_off,
                        trailingIconSize: 50,
                        tailingIconColor: AppColors.iconsDefault

                    ),

                    CustomListTile(
                      
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> const ChangePassword())
                          );
                        },
                        iconLeading: Icons.safety_check_sharp,
                        title: "Change Password",
                        subtitle: "Further secure your account for safety ",
                        iconTrailing: Icons.chevron_right
                    ),

                   const CustomListTile(
                        iconLeading: Icons.logout,
                        title: "Log Out",
                        subtitle: "Further secure your account for safety",
                        iconTrailing: Icons.chevron_right
                    ),
                    

                  ],
                ),
              ),


              const SizedBox(height: 20,),
              const Text("More",
                style:TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                ) ,),
              const SizedBox(height: 12,),
              const CustomContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [

                  CustomListTile(
                      iconLeading: Icons.notifications ,
                      title: "Help and Support",
                      iconTrailing: Icons.chevron_right
                  ),

                  CustomListTile(
                      iconLeading: Icons.favorite_border_outlined,
                      title: "About App",
                      iconTrailing: Icons.chevron_right
                  )
                ],
              ),

              ),


              const SizedBox(height: 50,),
            ],

          ),
        ),
      ),
     );

  }
}
