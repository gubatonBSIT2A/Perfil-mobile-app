import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfil/services/cloud/profile/constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudProfile {
  final String documentId;
  final String barangay;
  final String birthday;
  final String city;
  final String civilStatus;
  final String dateIssued;
  final String email;
  final String establishment;
  final String ethnicity;
  final String fathersName;
  final String firstName;
  final String gender;
  final String highestEducation;
  final String lastName;
  final String middleName;
  final String mothersName;
  final String nationality;
  final String patientId;
  final String phoneNumber;
  final String refId;
  final String religion;
  final String resCertNo;
  CloudProfile({
    required this.documentId,
    required this.barangay,
    required this.birthday,
    required this.city,
    required this.civilStatus,
    required this.dateIssued,
    required this.email,
    required this.establishment,
    required this.ethnicity,
    required this.fathersName,
    required this.firstName,
    required this.gender,
    required this.highestEducation,
    required this.lastName,
    required this.middleName,
    required this.mothersName,
    required this.nationality,
    required this.patientId,
    required this.phoneNumber,
    required this.refId,
    required this.religion,
    required this.resCertNo,
  });
  CloudProfile.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentId = snapshot.id,
        barangay = snapshot.data()[barangayFieldName],
        birthday = snapshot.data()[birthdayFieldName],
        city = snapshot.data()[cityFieldName],
        civilStatus = snapshot.data()[civilStatusFieldName],
  // convert dateIssued to String and format it to MM/dd/yyyy
        dateIssued = snapshot.data()[dateIssuedFieldName].toDate().toString().substring(0, 10),

        email = snapshot.data()[emailFieldName],
        establishment = snapshot.data()[establishmentFieldName],
        ethnicity = snapshot.data()[ethnicityFieldName],
        fathersName = snapshot.data()[fathersNameFieldName],
        firstName = snapshot.data()[firstNameFieldName],
        gender = snapshot.data()[genderFieldName],
        highestEducation = snapshot.data()[highestEducationFieldName],
        lastName = snapshot.data()[lastNameFieldName],
        middleName = snapshot.data()[middleNameFieldName],
        mothersName = snapshot.data()[mothersNameFieldName],
        nationality = snapshot.data()[nationalityFieldName],
        patientId = snapshot.data()[patientIdFieldName],
        phoneNumber = snapshot.data()[phoneNumberFieldName],
        refId = snapshot.data()[refIdFieldName],
        religion = snapshot.data()[religionFieldName],
        resCertNo = snapshot.data()[resCertNoFieldName];
}
