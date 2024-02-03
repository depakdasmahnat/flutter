import 'dart:convert';

ResourceModel resourceModelFromJson(String str) => ResourceModel.fromJson(json.decode(str));

String resourceModelToJson(ResourceModel data) => json.encode(data.toJson());

class ResourceModel {
  ResourceModel({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<Data>? data,
  }) {
    _status = status;
    _message = message;
    _dataRecords = dataRecords;
    _data = data;
  }

  ResourceModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  DataRecords? _dataRecords;
  List<Data>? _data;

  bool? get status => _status;

  String? get message => _message;

  DataRecords? get dataRecords => _dataRecords;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_dataRecords != null) {
      map['data_records'] = _dataRecords?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    num? id,
    num? categoryId,
    String? path,
    String? file,
  }) {
    _id = id;
    _categoryId = categoryId;
    _path = path;
    _file = file;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _path = json['path'];
    _file = json['file'];
  }

  num? _id;
  num? _categoryId;
  String? _path;
  String? _file;

  num? get id => _id;

  num? get categoryId => _categoryId;

  String? get path => _path;

  String? get file => _file;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['path'] = _path;
    map['file'] = _file;
    return map;
  }
}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));

String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());

class DataRecords {
  DataRecords({
    num? totalPage,
    num? limit,
    num? page,
  }) {
    _totalPage = totalPage;
    _limit = limit;
    _page = page;
  }

  DataRecords.fromJson(dynamic json) {
    _totalPage = json['total_page'];
    _limit = json['limit'];
    _page = json['page'];
  }

  num? _totalPage;
  num? _limit;
  num? _page;

  num? get totalPage => _totalPage;

  num? get limit => _limit;

  num? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = _totalPage;
    map['limit'] = _limit;
    map['page'] = _page;
    return map;
  }
}
