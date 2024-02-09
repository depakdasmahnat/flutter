import 'dart:convert';

Fetchproductdetail fetchproductdetailFromJson(String str) => Fetchproductdetail.fromJson(json.decode(str));

String fetchproductdetailToJson(Fetchproductdetail data) => json.encode(data.toJson());

class Fetchproductdetail {
  Fetchproductdetail({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Fetchproductdetail.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
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
    String? path,
    String? productVideo,
    String? productImage,
    List<String>? images,
  }) {
    _id = id;
    _name = name;
    _price = price;
    _description = description;
    _path = path;
    _productVideo = productVideo;
    _productImage = productImage;
    _images = images;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
    _description = json['description'];
    _path = json['path'];
    _productVideo = json['product_video'];
    _productImage = json['product_image'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
  }

  num? _id;
  String? _name;
  String? _price;
  String? _description;
  String? _path;
  String? _productVideo;
  String? _productImage;
  List<String>? _images;

  num? get id => _id;

  String? get name => _name;

  String? get price => _price;

  String? get description => _description;

  String? get path => _path;

  String? get productVideo => _productVideo;

  String? get productImage => _productImage;

  List<String>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    map['description'] = _description;
    map['path'] = _path;
    map['product_video'] = _productVideo;
    map['product_image'] = _productImage;
    map['images'] = _images;
    return map;
  }
}
