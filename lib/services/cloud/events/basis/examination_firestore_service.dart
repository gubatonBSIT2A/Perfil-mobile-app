import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:perfil/services/cloud/events/data_constants.dart';
import 'app_examination.dart';

final examDBS = DatabaseService<AppExamination>(
  AppDBConstants.examinationsCollection,
  fromDS: (id, data) => AppExamination.fromDS(id, data!),
  toMap: (event) => event.toMap(),
);