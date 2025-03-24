import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaclean/presentation/screens/profile/PasswordResetSuccessDialog.dart';
import 'package:jaclean/presentation/widgets/custom_full_elevated_btn.dart';
import 'package:jaclean/blocs/profile/change_password_bloc.dart';
import 'package:jaclean/blocs/profile/profile_bloc.dart' as profile;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangePasswordBloc(),
        ),
        BlocProvider(
          create: (context) => profile.ProfileBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "New Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    hintText: '•••••••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: '•••••••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccess) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PasswordResetSuccessDialog(
                            onProceed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed('/mainProfile');
                            },
                          );
                        },
                      );
                    } else if (state is ChangePasswordFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChangePasswordLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomFullElevatedBtn(
                      onPressed: () {
                        context.read<ChangePasswordBloc>().add(
                          ChangePasswordSubmitted(
                            newPassword: _newPasswordController.text.trim(),
                            confirmPassword: _confirmPasswordController.text.trim(),
                          ),
                        );
                      },
                      text: "Submit",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}