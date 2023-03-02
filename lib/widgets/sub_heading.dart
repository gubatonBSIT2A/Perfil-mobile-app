import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  const SubHeading({Key? key, required this.title}) : super(key: key);
  final title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
