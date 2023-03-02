import 'package:flutter/material.dart';
import 'package:perfil/theme/theme_constant.dart';
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key, required this.title, required this.onPressed}) : super(key: key);
final title;
final onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(

      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: primaryColor),
      ),
    );
  }
}
