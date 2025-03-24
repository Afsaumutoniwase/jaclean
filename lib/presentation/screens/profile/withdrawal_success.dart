import 'package:flutter/material.dart';
import 'package:jaclean/presentation/theme/app_colors.dart';
import 'package:jaclean/presentation/widgets/custom_full_elevated_btn.dart';
import 'package:jaclean/main.dart'; // ✅ Import MainScreen to use initialIndex

class WithdrawalSuccess extends StatelessWidget {
  final double newBalance;

  const WithdrawalSuccess({super.key, required this.newBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: 306,
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_sharp, size: 250, color: AppColors.primaryGreen),
              const SizedBox(height: 15),
              const Text(
                "Withdrawal Successful",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(
                width: 250,
                child: Text(
                  "Your withdrawal is being processed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CustomFullElevatedBtn(
                onPressed: () {
                  // ✅ Use MainScreen with selected index for Profile (index 3)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 3),
                    ),
                    (route) => false,
                  );
                },
                text: "Go Back",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
