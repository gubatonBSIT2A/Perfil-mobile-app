// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppExamination {
  final String id;
  final String userId;
  final String examinationName;
  final DateTime examinationDate;
  final String examinationResult;
  final DateTime examinationDONA;
  final bool examinationIsMissed;
  final String examinationExaminedBy;
  AppExamination({
    required this.id,
    required this.userId,
    required this.examinationName,
    required this.examinationDate,
    required this.examinationResult,
    required this.examinationDONA,
    required this.examinationIsMissed,
    required this.examinationExaminedBy,
  });

  AppExamination copyWith({
    String? id,
    String? userId,
    String? examinationName,
    DateTime? examinationDate,
    String? examinationResult,
    DateTime? examinationDONA,
    bool? examinationIsMissed,
    String? examinationExaminedBy,
  }) {
    return AppExamination(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      examinationName: examinationName ?? this.examinationName,
      examinationDate: examinationDate ?? this.examinationDate,
      examinationResult: examinationResult ?? this.examinationResult,
      examinationDONA: examinationDONA ?? this.examinationDONA,
      examinationIsMissed: examinationIsMissed ?? this.examinationIsMissed,
      examinationExaminedBy:
          examinationExaminedBy ?? this.examinationExaminedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'examinationName': examinationName,
      'examinationDate': examinationDate.millisecondsSinceEpoch,
      'examinationResult': examinationResult,
      'examinationDONA': examinationDONA.millisecondsSinceEpoch,
      'examinationIsMissed': examinationIsMissed,
      'examinationExaminedBy': examinationExaminedBy,
    };
  }

  factory AppExamination.fromMap(Map<String, dynamic> map) {
    return AppExamination(
      id: map['id'],
      userId: map['userId'],
      examinationName: map['examinationName'],
      examinationDate:
          DateTime.fromMillisecondsSinceEpoch(map['examinationDate']),
      examinationResult: map['examinationResult'],
      examinationDONA:
          DateTime.fromMillisecondsSinceEpoch(map['examinationDONA']),
      examinationIsMissed: map['examinationIsMissed'],
      examinationExaminedBy: map['examinationExaminedBy'],
    );
  }
  factory AppExamination.fromDS(String id, Map<String, dynamic> data) {
    // if (data == null) return null;
    return AppExamination(
      id: id,
      userId: data['userId'],
      examinationName: data['examinationName'],
      examinationDate:
          DateTime.fromMillisecondsSinceEpoch(data['examinationDate']),
      examinationResult: data['examinationResult'],
      examinationDONA:
          DateTime.fromMillisecondsSinceEpoch(data['examinationDONA']),
      examinationIsMissed: data['examinationIsMissed'],
      examinationExaminedBy: data['examinationExaminedBy'],
    );
  }
  String toJson() => json.encode(toMap());

  factory AppExamination.fromJson(String source) =>
      AppExamination.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppExamination(id: $id, userId: $userId, examinationName: $examinationName, examinationDate: $examinationDate, examinationResult: $examinationResult, examinationDONA: $examinationDONA, examinationIsMissed: $examinationIsMissed, examinationExaminedBy: $examinationExaminedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppExamination &&
        other.id == id &&
        other.userId == userId &&
        other.examinationName == examinationName &&
        other.examinationDate == examinationDate &&
        other.examinationResult == examinationResult &&
        other.examinationDONA == examinationDONA &&
        other.examinationIsMissed == examinationIsMissed &&
        other.examinationExaminedBy == examinationExaminedBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        examinationName.hashCode ^
        examinationDate.hashCode ^
        examinationResult.hashCode ^
        examinationDONA.hashCode ^
        examinationIsMissed.hashCode ^
        examinationExaminedBy.hashCode;
  }
}
