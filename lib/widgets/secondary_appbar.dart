import 'package:flutter/material.dart';

class SecondaryAppBar extends StatelessWidget {
  SecondaryAppBar({Key? key, required this.title, this.actions}) : super(key: key);
  final title;
  List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: actions,
        elevation: 4,
      pinned: true,
      iconTheme: const IconThemeData(
        color: Colors.black
      ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ));
  }
}
