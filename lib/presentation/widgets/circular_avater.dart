import 'package:flutter/material.dart';


class CircularAvatar extends StatelessWidget {
  final double radius ;
  final Color backgroundColor;
  final String backgroundUrl ;
  
  const CircularAvatar({
    super.key,
    required this.radius,
    required this.backgroundColor,
    required this.backgroundUrl,
  });
  

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(backgroundUrl));
  }
}
