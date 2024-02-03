import 'dart:convert';

FetchFaqsModel fetchFaqsModelFromJson(String str) => FetchFaqsModel.fromJson(json.decode(str));

String fetchFaqsModelToJson(FetchFaqsModel data) => json.encode(data.toJson());

class FetchFaqsModel {
  FetchFaqsModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  FetchFaqsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['data_records'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.id,
    this.question,
    this.answer,
    this.category,
    this.categoryName,
    this.position,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    category = json['category'];
    categoryName = json['category_name'];
    position = json['position'];
  }

  num? id;
  String? question;
  String? answer;
  num? category;
  String? categoryName;
  String? position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['answer'] = answer;
    map['category'] = category;
    map['category_name'] = categoryName;
    map['position'] = position;
    return map;
  }
}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));

String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());

class DataRecords {
  DataRecords({
    this.totalPage,
    this.limit,
    this.page,
  });

  DataRecords.fromJson(dynamic json) {
    totalPage = json['total_page'];
    limit = json['limit'];
    page = json['page'];
  }

  num? totalPage;
  num? limit;
  num? page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }
}
