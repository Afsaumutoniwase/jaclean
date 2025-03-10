import 'package:flutter/material.dart';
import '../../widgets/custom_success_dialog.dart';

class PasswordResetSuccessDialog extends StatelessWidget {
  const PasswordResetSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSuccessDialog(
        onProceed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        },
        messageTitle: "Password reset successfully !",
        subtitle: "You can now login with your new password." ,
        proceedText: "Proceed");
  }
}
