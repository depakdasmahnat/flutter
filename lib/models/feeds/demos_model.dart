import 'dart:convert';

import '../feeds/feeds_data.dart';

DemosModel demosModelFromJson(String str) => DemosModel.fromJson(json.decode(str));

String demosModelToJson(DemosModel data) => json.encode(data.toJson());

class DemosModel {
  DemosModel({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<FeedsData>? data,
  }) {
    _status = status;
    _message = message;
    _dataRecords = dataRecords;
    _data = data;
  }

  DemosModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FeedsData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  DataRecords? _dataRecords;
  List<FeedsData>? _data;

  bool? get status => _status;

  String? get message => _message;

  DataRecords? get dataRecords => _dataRecords;

  List<FeedsData>? get data => _data;

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
