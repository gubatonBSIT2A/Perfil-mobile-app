import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfil/services/cloud/results/cloud_results.dart';

class ResultsCloudStorage{
  final results = FirebaseFirestore.instance.collection('exam-results');
  Stream<Iterable<CloudResults>> allResults({required String patientId}) =>
      results.snapshots().map((event) => event.docs
          .map((doc) => CloudResults.fromSnapshot(doc))
          .where((result) => result.patientId == patientId));
}