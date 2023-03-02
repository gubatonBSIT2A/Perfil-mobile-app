import 'package:perfil/services/auth/auth_provider.dart';
import 'package:perfil/services/auth/auth_user.dart';
import 'package:perfil/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String patientId,
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String password,
    required String birthday,
    required String gender,
    required String mothersName,
    required String fathersName,
    required String religion,
    required String ethnicity,
    required String nationality,
    required String city,
    required String barangay,
    required String resCertNo,
    required String highestEducation,
    required String civilStatus,
    required String phoneNumber,
    required String establishment,


  }) =>
      provider.createUser(
        patientId: patientId,
        email: email,
        password: password,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        birthday: birthday,
        gender: gender,
        mothersName: mothersName,
        fathersName: fathersName,
        religion: religion,
        ethnicity: ethnicity,
        nationality: nationality,
        city: city,
        barangay: barangay,
        resCertNo: resCertNo,
        highestEducation: highestEducation,
        civilStatus: civilStatus,
        phoneNumber: phoneNumber,
        establishment: establishment,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);
}
