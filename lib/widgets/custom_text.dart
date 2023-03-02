import 'package:flutter/material.dart';
import 'package:perfil/theme/theme_constant.dart';

class CustomText extends StatelessWidget {
  const CustomText({Key? key, required this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: newBlack,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
