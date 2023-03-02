import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfil/services/cloud/events/appointments/app_appointment.dart';

import '../widgets/normal_appbar.dart';

class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({Key? key, required this.appointment})
      : super(key: key);
  final AppAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(title: 'Examination Details'),
      ),
      body: Column(
        children: [

          ListTile(
            title: Text(appointment.title),
            subtitle: const Text('Examination Name'),
          ),
          ListTile(
            title: Text(DateFormat('EEE, dd MMMM, yyyy')
                .format(appointment.start)),
            subtitle: const Text('Start Date'),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text(DateFormat('EEE, dd MMMM, yyyy')
                .format(appointment.end)),
            subtitle: const Text('End Date'),
          ),
        ],
      ),
    );
  }
}
