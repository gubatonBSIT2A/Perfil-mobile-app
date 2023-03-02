import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:perfil/services/cloud/results/results_storage_constants.dart';

@immutable
class CloudResults {
  final String documentId;
  final String appointmentId;
  final int dateExamined;
  final List<String> diagnosis;
  final int dona;
  final String establishmentId;
  final String examinationId;
  final String examinationName;
  final String examinedBy;
  final String patientAge;
  final String patientBarangay;
  final String patientCity;
  final String patientCivilStatus;
  final String patientFirstName;
  final String patientGender;
  final String patientHighestEducation;
  final String patientId;
  final String patientLastName;
  final String patientMiddleName;
  final String remarks;
  final String result;
  final String receipt;
  const CloudResults({
    required this.documentId,
    required this.appointmentId,
    required this.dateExamined,
    this.diagnosis = const [],
    required this.dona,
    required this.establishmentId,
    required this.examinationId,
    required this.examinationName,
    required this.examinedBy,
    required this.patientAge,
    required this.patientBarangay,
    required this.patientCity,
    required this.patientCivilStatus,
    required this.patientFirstName,
    required this.patientGender,
    required this.patientHighestEducation,
    required this.patientId,
    required this.patientLastName,
    required this.patientMiddleName,
    this.remarks = '',
    required this.result,
    this.receipt = '',
  });
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'appointmentId': appointmentId,
      'dateExamined': dateExamined,
      'diagnosis': diagnosis,
      'dona': dona,
      'establishmentId': establishmentId,
      'examinationId': examinationId,
      'examinationName': examinationName,
      'examinedBy': examinedBy,
      'patientAge': patientAge,
      'patientBarangay': patientBarangay,
      'patientCity': patientCity,
      'patientCivilStatus': patientCivilStatus,
      'patientFirstName': patientFirstName,
      'patientGender': patientGender,
      'patientHighestEducation': patientHighestEducation,
      'patientId': patientId,
      'patientLastName': patientLastName,
      'patientMiddleName': patientMiddleName,
      'remarks': remarks,
      'result': result,
      'receipt': receipt,
    };
  }

  CloudResults.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        appointmentId = snapshot.data()[appointmentIdFieldName],
        dateExamined = snapshot.data()[dateExaminedFieldName],
        diagnosis = snapshot.data()[diagnosisFieldName] is String
            ? [snapshot.data()[diagnosisFieldName] as String]
            : (snapshot.data()[diagnosisFieldName] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      dona = snapshot.data()[donaFieldName],
        establishmentId = snapshot.data()[establishmentIdFieldName],
        examinationId = snapshot.data()[examinationIdFieldName],
        examinationName = snapshot.data()[examinationNameFieldName],
        examinedBy = snapshot.data()[examinedByFieldName],
        patientAge = snapshot.data()[patientAgeFieldName],
        patientBarangay = snapshot.data()[patientBarangayFieldName],
        patientCity = snapshot.data()[patientCityFieldName],
        patientCivilStatus = snapshot.data()[patientCivilStatusFieldName],
        patientFirstName = snapshot.data()[patientFirstNameFieldName],
        patientGender = snapshot.data()[patientGenderFieldName],
        patientHighestEducation = snapshot.data()[patientHighestEducationFieldName],
        patientId = snapshot.data()[patientIdFieldName],
        patientLastName = snapshot.data()[patientLastNameFieldName],
        patientMiddleName = snapshot.data()[patientMiddleNameFieldName],
        remarks = snapshot.data()[remarksFieldName],
        result = snapshot.data()[resultFieldName],
        receipt = snapshot.data()[receiptFieldName];
}