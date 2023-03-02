import 'package:flutter/material.dart';
class AccountItemContainer extends StatelessWidget {
  const AccountItemContainer({Key? key, required this.children}) : super(key: key);

final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
