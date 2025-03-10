import 'package:flutter/material.dart';

import '../../widgets/custom_full_elevated_btn.dart';
import '../../widgets/custom_password_input.dart';
import 'PasswordResetSuccessDialog.dart';



class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 40,),
              const Text("New Password",style:TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ) ,),
              const  SizedBox(height: 10,),
              const CustomPasswordInput(hintText: '•••••••••••••'),
              const SizedBox(height: 20,),
              const Text("Confirm Password",
              textAlign: TextAlign.left,
              style: TextStyle(

                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),),
            const CustomPasswordInput(hintText: '•••••••••••••'),
            const SizedBox(height: 10,),
            const SizedBox(height: 20),
            CustomFullElevatedBtn(
                onPressed:(){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return const PasswordResetSuccessDialog();

                    });
                },
                text: "Submit"

            )

              
            ],
          ),
        ),
      ),
    );


  }
}
