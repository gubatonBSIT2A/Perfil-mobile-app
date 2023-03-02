import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/cloud/events/app_event.dart';
import '../widgets/normal_appbar.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);
  final AppEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(title: 'Event Details'),
      ),
      body: Column(
        children: [
          Text(event.public ? 'Public' : 'Private'),
          ListTile(
            title: Text(
              event.title,
            ),
            subtitle: Text(
              DateFormat('EEE, dd MMMM, yyyy').format(event.date),
            ),
          ),
          const SizedBox( height: 10),
          if(event.description != null)
             ListTile(title: Text(event.description)),
          const SizedBox( height: 20),


        ],
      ),
    );
  }
}
