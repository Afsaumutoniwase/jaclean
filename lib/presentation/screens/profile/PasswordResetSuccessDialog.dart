import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/presentation/widgets/custom_success_dialog.dart';
import 'package:jaclean/blocs/profile/password_reset_success_dialog_bloc.dart';

class PasswordResetSuccessDialog extends StatelessWidget {
  final VoidCallback onProceed;

  const PasswordResetSuccessDialog({super.key, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetSuccessDialogBloc(),
      child: BlocListener<PasswordResetSuccessDialogBloc, PasswordResetSuccessDialogState>(
        listener: (context, state) {
          if (state is PasswordResetSuccessDialogProceeding) {
            onProceed();
          }
        },
        child: CustomSuccessDialog(
          onProceed: () {
            context.read<PasswordResetSuccessDialogBloc>().add(ProceedEvent());
          },
          messageTitle: 'Password Changed Successfully',
          subtitle: 'Your password has been changed successfully. Please log in again with your new password.',
          proceedText: 'Proceed',
        ),
      ),
    );
  }
}