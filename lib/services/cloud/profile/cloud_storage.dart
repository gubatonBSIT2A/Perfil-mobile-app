import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfil/services/cloud/profile/constants.dart';
import 'package:perfil/services/cloud/profile/cloud_profile.dart';
import 'package:perfil/services/cloud/profile/profile_exceptions.dart';

class CloudStorage {
  final patientsRef = FirebaseFirestore.instance.collection('patients');
  // Future<void> updateProfile({
  //   required String documentId,
  //   required String firstName,
  //   required String lastName,
  //   required String middleName,
  //   required String gender,
  //   required String region,
  //   required String province,
  //   required String city,
  //   required String barangay,
  //   required String civilStatus,
  //   required String education,
  //   required String ethnicity,
  //   required String fathersName,
  //   required String mothersName,
  //   required String nationality,
  //   required String phoneNumber,
  //   required String religion,
  //   required String residentCertNo,
  //   required String establishment,
  // }) async {
  //   try {
  //     patientsRef.doc(documentId).update({
  //       firstNameFieldName: firstName,
  //       lastNameFieldName: lastName,
  //       middleNameFieldName: middleName,
  //       genderFieldName: gender,
  //       regionFieldName: region,
  //       provinceFieldName: province,
  //       cityFieldName: city,
  //       barangayFieldName: barangay,
  //       civilStatusFieldName: civilStatus,
  //       educationFieldName: education,
  //       ethnicityFieldName: ethnicity,
  //       fathersNameFieldName: fathersName,
  //       mothersNameFieldName: mothersName,
  //       nationalityFieldName: nationality,
  //       phoneNumberFieldName: phoneNumber,
  //       religionFieldName: religion,
  //       residentCertNoFieldName: residentCertNo,
  //       establishmentFieldName: establishment,
  //     });
  //   } catch (e) {
  //     throw CouldNotUpdateProfileException();
  //   }
  // }

  Stream<Iterable<CloudProfile>> allProfiles({required String ownerUserId}) =>
      patientsRef.snapshots().map((event) => event.docs
          .map((doc) => CloudProfile.fromSnapshot(doc))
          .where((note) => note.refId == ownerUserId));

  // Future<Iterable<CloudProfile>> getProfiles(
  //     {required String ownerUserId}) async {
  //   try {
  //     return await patientsRef
  //         .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
  //         .get()
  //         .then(
  //           (value) => value.docs.map(
  //             (doc) => CloudProfile.fromSnapshot(doc),
  //           ),
  //         );
  //   } catch (e) {
  //     throw CouldNotGetProfileException();
  //   }
  // }

  // static final CloudStorage _shared = CloudStorage._sharedInstance();
  // CloudStorage._sharedInstance();
  // factory CloudStorage() => _shared;
}
