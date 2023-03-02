import 'package:flutter/material.dart';

import '../theme/theme_constant.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 25,
            color: secondaryColor,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              // fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          dense: true,
        ),
        const Divider(),
      ],
    );
  }
}
