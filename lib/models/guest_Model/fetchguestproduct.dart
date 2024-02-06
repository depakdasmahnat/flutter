import 'dart:convert';
Fetchguestproduct fetchguestproductFromJson(String str) => Fetchguestproduct.fromJson(json.decode(str));
String fetchguestproductToJson(Fetchguestproduct data) => json.encode(data.toJson());
class Fetchguestproduct {
  Fetchguestproduct({
      bool? status, 
      String? message, 
      DataRecords? dataRecords, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _dataRecords = dataRecords;
    _data = data;
}

  Fetchguestproduct.fromJson(dynamic json) {
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
      String? name, 
      String? price, 
      String? description, 
      String? subHeading,
      dynamic productVideo,
      dynamic path, 
      String? productImage,}){
    _id = id;
    _name = name;
    _price = price;
    _description = description;
    _productVideo = productVideo;
    _path = path;
    _subHeading = subHeading;
    _productImage = productImage;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
    _description = json['description'];
    _productVideo = json['product_video'];
    _path = json['path'];
    _subHeading = json['sub_heading'];
    _productImage = json['product_image'];
  }
  num? _id;
  String? _name;
  String? _price;
  String? _description;
  dynamic _productVideo;
  dynamic _path;
  String? _productImage;
  String? _subHeading;

  num? get id => _id;
  String? get name => _name;
  String? get price => _price;
  String? get description => _description;
  dynamic get productVideo => _productVideo;
  dynamic get path => _path;
  String? get productImage => _productImage;
  String? get subHeading => _subHeading;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    map['description'] = _description;
    map['product_video'] = _productVideo;
    map['path'] = _path;
    map['product_image'] = _productImage;
    map['sub_heading'] = _subHeading;
    return map;
  }

}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));
String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());
class DataRecords {
  DataRecords({
      num? totalPage, 
      num? limit, 
      num? page,}){
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