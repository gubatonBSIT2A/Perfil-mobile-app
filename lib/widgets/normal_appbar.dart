import 'package:flutter/material.dart';

class NormalAppBar extends StatelessWidget {
NormalAppBar({Key? key, required this.title, this.actions}) : super(key: key);
  final title;
  List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      elevation: 1,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 22,
      ),
      title: Text(title),
      actions: actions,
    );
  }
}
