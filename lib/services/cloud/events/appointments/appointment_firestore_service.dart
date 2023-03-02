import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:perfil/services/cloud/events/appointments/app_appointment.dart';
import 'package:perfil/services/cloud/events/data_constants.dart';

final appointmentDBS = DatabaseService<AppAppointment>(
  AppDBConstants.appointmentsCollection,
  fromDS: (id, data) => AppAppointment.fromDS(id, data!),
  toMap: (event) => event.toMap(),
);