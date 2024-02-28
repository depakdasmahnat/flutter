import 'dart:convert';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  ServicesModel({
    this.status,
    this.message,
    this.data,
  });

  ServicesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ServicesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ServicesData>? data;

  ServicesModel copyWith({
    bool? status,
    String? message,
    List<ServicesData>? data,
  }) =>
      ServicesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ServicesData dataFromJson(String str) => ServicesData.fromJson(json.decode(str));

String dataToJson(ServicesData data) => json.encode(data.toJson());

class ServicesData {
  ServicesData({
    this.id,
    this.name,
    this.city,
    this.contactNumber,
    this.alternateNumber,
  });

  ServicesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    contactNumber = json['contact_number'];
    alternateNumber = json['alternate_number'];
  }

  num? id;
  String? name;
  String? city;
  String? contactNumber;
  dynamic alternateNumber;

  ServicesData copyWith({
    num? id,
    String? name,
    String? city,
    String? contactNumber,
    dynamic alternateNumber,
  }) =>
      ServicesData(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        contactNumber: contactNumber ?? this.contactNumber,
        alternateNumber: alternateNumber ?? this.alternateNumber,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['city'] = city;
    map['contact_number'] = contactNumber;
    map['alternate_number'] = alternateNumber;
    return map;
  }
}
