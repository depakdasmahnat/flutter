import 'dart:convert';

PartnerTimeSlotDatesModel partnerTimeSlotDatesModelFromJson(String str) =>
    PartnerTimeSlotDatesModel.fromJson(json.decode(str));

String partnerTimeSlotDatesModelToJson(PartnerTimeSlotDatesModel data) => json.encode(data.toJson());

class PartnerTimeSlotDatesModel {
  PartnerTimeSlotDatesModel({
    this.status,
    this.message,
    this.counts,
    this.data,
  });

  PartnerTimeSlotDatesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    counts = json['counts'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PartnerTimeSlotDates.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? counts;
  List<PartnerTimeSlotDates>? data;

  PartnerTimeSlotDatesModel copyWith({
    bool? status,
    String? message,
    num? counts,
    List<PartnerTimeSlotDates>? data,
  }) =>
      PartnerTimeSlotDatesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        counts: counts ?? this.counts,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['counts'] = counts;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

PartnerTimeSlotDates datesFromJson(String str) => PartnerTimeSlotDates.fromJson(json.decode(str));

String datesToJson(PartnerTimeSlotDates data) => json.encode(data.toJson());

class PartnerTimeSlotDates {
  PartnerTimeSlotDates({
    this.title,
    this.date,
    this.dateLabel,
  });

  PartnerTimeSlotDates.fromJson(dynamic json) {
    title = json['title'];
    date = json['date'];
    dateLabel = json['date_label'];
  }

  String? title;
  String? date;
  String? dateLabel;

  PartnerTimeSlotDates copyWith({
    String? title,
    String? data,
    String? dateLabel,
  }) =>
      PartnerTimeSlotDates(
        title: title ?? this.title,
        date: data ?? this.date,
        dateLabel: dateLabel ?? this.dateLabel,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['date'] = date;
    map['date_label'] = dateLabel;
    return map;
  }
}
