import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
   OutlinedTextField({
    Key? key,
    required this.label,
    this.prefixIcon,
    this.textInputAction,
    required this.controller,
    this.suffixIcon,
     this.keyboardType,
     required this.obscureText,
     this.validator,
     required this.readOnly,
     this.onTap,
     this.maxLines,
  }) : super(key: key);

  final String label;
  Icon? prefixIcon;
  TextInputAction? textInputAction;
  TextEditingController controller;
  TextInputType? keyboardType;
  Widget? suffixIcon;
  bool obscureText;
  bool readOnly;
  int? maxLines;
 final validator;
 Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        maxLines: maxLines,
        onTap: onTap,
        readOnly: readOnly,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: TextCapitalization.sentences,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          label: Text(label),
        ),
      ),
    );
  }
}
