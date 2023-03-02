// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppAppointment {
  final String id;
  final String establishment;
  final String title;
  final DateTime start;
  final DateTime end;
  final String backgroundColor;
  AppAppointment({
    required this.id,
    required this.establishment,
    required this.title,
    required this.start,
    required this.end,
    required this.backgroundColor,
  });

  AppAppointment copyWith({
    String? id,
    String? establishment,
    DateTime? start,
    String? title,
    DateTime? end,
    String? backgroundColor,
  }) {
    return AppAppointment(
      id: id ?? this.id,
      establishment: establishment ?? this.establishment,
      start: start ?? this.start,
      title: title ?? this.title,
      end: end ?? this.end,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'establishment': establishment,
      'start': start.millisecondsSinceEpoch,
      'title': title,
      'end': end.millisecondsSinceEpoch,
      'backgroundColor': backgroundColor,
    };
  }

  factory AppAppointment.fromMap(Map<String, dynamic> map) {
    return AppAppointment(
      id: map['id'],
      establishment: map['establishment'],
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
      title: map['title'],
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
      backgroundColor: map['backgroundColor'],
    );
  }
  factory AppAppointment.fromDS(String id, Map<String, dynamic> data) {
    // if (data == null) return null;
    return AppAppointment(
      id: id,
      establishment: data['establishment'],
      start: DateTime.fromMillisecondsSinceEpoch(data['start']),
      title: data['title'],
      end: DateTime.fromMillisecondsSinceEpoch(data['end']),
      backgroundColor: data['backgroundColor'],
    );
  }
  String toJson() => json.encode(toMap());

  factory AppAppointment.fromJson(String source) =>
      AppAppointment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppExamination(id: $id, establishment: $establishment, start: $start, title: $title, end: $end, backgroundColor: $backgroundColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppAppointment &&
        other.id == id &&
        other.establishment == establishment &&
        other.start == start &&
        other.title == title &&
        other.end == end &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        establishment.hashCode ^
        start.hashCode ^
        title.hashCode ^
        end.hashCode ^
        backgroundColor.hashCode;
  }
}
