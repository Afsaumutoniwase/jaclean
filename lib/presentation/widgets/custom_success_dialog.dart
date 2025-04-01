import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'custom_elevated_btn.dart';

class CustomSuccessDialog extends StatelessWidget {
  final VoidCallback onProceed;
  final String messageTitle;
  final String subtitle;
  final String proceedText;

  const CustomSuccessDialog({
    super.key,
    required this.onProceed,
    required this.messageTitle,
    required this.subtitle,
    required this.proceedText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              messageTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomElevatedBtn(
                onPressed: onProceed,
                text: proceedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}