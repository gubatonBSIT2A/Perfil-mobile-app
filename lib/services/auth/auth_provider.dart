import 'package:perfil/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
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
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
