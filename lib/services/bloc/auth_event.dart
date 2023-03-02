import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String patientId;
  final String email;
  final String password;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthday;
  final String gender;
  final String mothersName;
  final String fathersName;
  final String religion;
  final String ethnicity;
  final String nationality;
  final String city;
  final String barangay;
  final String resCertNo;
  final String highestEducation;
  final String civilStatus;
  final String phoneNumber;
  final String establishment;
  const AuthEventRegister(
    this.patientId,
    this.email,
    this.password,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthday,
    this.gender,
    this.mothersName,
    this.fathersName,
    this.religion,
    this.ethnicity,
    this.nationality,
    this.city,
    this.barangay,
    this.resCertNo,
    this.highestEducation,
    this.civilStatus,
    this.phoneNumber,
    this.establishment,
  );
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
