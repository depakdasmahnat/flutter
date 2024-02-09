import 'dart:convert';

TimeslotDates timeslotDatesFromJson(String str) => TimeslotDates.fromJson(json.decode(str));

String timeslotDatesToJson(TimeslotDates data) => json.encode(data.toJson());

class TimeslotDates {
  TimeslotDates({
    this.status,
    this.message,
    this.data,
  });

  TimeslotDates.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? json['data'].cast<String>() : [];
  }

  bool? status;
  String? message;
  List<String>? data;

  TimeslotDates copyWith({
    bool? status,
    String? message,
    List<String>? data,
  }) =>
      TimeslotDates(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}
