import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/custom_full_elevated_btn.dart';



class WithdrawalSuccess extends StatelessWidget {
  const WithdrawalSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Withdraw"),),
      body: Center(
        child: Container(
          width:306,
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Icon(Icons.check_circle_sharp, size: 250, color:AppColors.primaryGreen,),
              const SizedBox(height:15,),
              const Text(
                "Withdrawal Successful",
                style:TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 15,),
              const SizedBox(
                width: 250,

                child: Text(

                  "Your withdrawal is being processed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
              const SizedBox(height:25,),
              CustomFullElevatedBtn(onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);



              }, text: "Go Back")


            ],
          ),

        ),
      ),
    );
  }
}
