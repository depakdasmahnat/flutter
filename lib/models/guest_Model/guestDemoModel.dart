import 'dart:convert';
GuestDemoModel guestDemoModelFromJson(String str) => GuestDemoModel.fromJson(json.decode(str));
String guestDemoModelToJson(GuestDemoModel data) => json.encode(data.toJson());
class GuestDemoModel {
  GuestDemoModel({
      this.status, 
      this.message, 
      this.data,});

  GuestDemoModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataForDemo.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<DataForDemo>? data;

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

DataForDemo dataFromJson(String str) => DataForDemo.fromJson(json.decode(str));
String dataToJson(DataForDemo data) => json.encode(data.toJson());
class DataForDemo {
  DataForDemo({
      this.id, 
      this.title, 
      this.fileType, 
      this.file,});

  DataForDemo.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    fileType = json['file_type'];
    file = json['file'];
  }
  num? id;
  String? title;
  String? fileType;
  String? file;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['file_type'] = fileType;
    map['file'] = file;
    return map;
  }

}