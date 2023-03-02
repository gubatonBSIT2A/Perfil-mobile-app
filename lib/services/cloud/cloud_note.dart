import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfil/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String establishment;
  final String title;
  final String description;
  final int dateCreated;
  const CloudNote({
    required this.documentId,
    required this.establishment,
    required this.title,
    required this.description,
    required this.dateCreated,
  });
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        establishment = snapshot.data()[establishmentIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        description = snapshot.data()[descriptionFieldName] as String,
        dateCreated = snapshot.data()[dateCreatedFieldName] as int;
}
