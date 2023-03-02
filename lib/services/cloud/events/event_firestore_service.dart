import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:perfil/services/cloud/events/app_event.dart';
import 'package:perfil/services/cloud/events/data_constants.dart';

final eventDBS = DatabaseService<AppEvent>(
  AppDBConstants.eventsCollection,
  fromDS: (id, data) => AppEvent.fromDS(id, data!),
  toMap: (event) => event.toMap(),
);


