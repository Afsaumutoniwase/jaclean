import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaclean/presentation/screens/profile/PasswordResetSuccessDialog.dart';
import '../../widgets/custom_full_elevated_btn.dart';
import '../../widgets/custom_password_input.dart';

// Create a simple dialog widget for success message


class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Controllers for password input fields
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Optionally, you could add a loading indicator variable
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Make sure your custom widget supports controller parameter
              CustomPasswordInput(
                hintText: '•••••••••••••',
                controller: _newPasswordController,
              ),
              const SizedBox(height: 20),
              const Text(
                "Confirm Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CustomPasswordInput(
                hintText: '•••••••••••••',
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 20),
              CustomFullElevatedBtn(
                onPressed: _handleChangePassword,
                text: "Submit",
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate that both password fields match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password cannot be empty")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure that a user is signed in
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user is currently signed in")),
        );
        return;
      }
      // Update the password
      await user.updatePassword(newPassword);

      // Optionally, you might want to authenticate the user if required:
      // await user.authenticateWithCredential(credential);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PasswordResetSuccessDialog();
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors, such as "requires-recent-login"
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
