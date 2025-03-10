import 'package:flutter/material.dart';


class CustomFullElevatedBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomFullElevatedBtn({
    super.key,
    required this.onPressed,
    required this.text,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,

      child: ElevatedButton(style:
          ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1FC776),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          onPressed:onPressed,
          child:Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
    ) ;
  }
}
