import 'package:flutter/material.dart';
import 'package:perfil/theme/theme_constant.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({Key? key, required this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: newBlack
      ),
    );
  }
}
