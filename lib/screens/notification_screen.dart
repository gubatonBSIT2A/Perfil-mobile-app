import 'package:flutter/material.dart';
import 'package:perfil/widgets/normal_appbar.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(title: 'Notifications'),

      ),
      body: SingleChildScrollView(
      ),
    );
  }
}
