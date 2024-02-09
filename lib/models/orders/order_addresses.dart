import 'dart:convert';
OrderAddressesModel orderAddressesFromJson(String str) => OrderAddressesModel.fromJson(json.decode(str));
String orderAddressesToJson(OrderAddressesModel data) => json.encode(data.toJson());
class OrderAddressesModel {
  OrderAddressesModel({
      this.status, 
      this.message, 
      this.data,});

  OrderAddressesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrderAddress.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<OrderAddress>? data;
OrderAddressesModel copyWith({  bool? status,
  String? message,
  List<OrderAddress>? data,
}) => OrderAddressesModel(  status: status ?? this.status,
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

OrderAddress dataFromJson(String str) => OrderAddress.fromJson(json.decode(str));
String dataToJson(OrderAddress data) => json.encode(data.toJson());
class OrderAddress {
  OrderAddress({
      this.id, 
      this.userId, 
      this.name, 
      this.addressType, 
      this.houseAddress, 
      this.locality, 
      this.landmark, 
      this.locLatitude, 
      this.locLongitude, 
      this.locAddress, 
      this.isDefault,});

  OrderAddress.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    addressType = json['address_type'];
    houseAddress = json['house_address'];
    locality = json['locality'];
    landmark = json['landmark'];
    locLatitude = json['loc_latitude'];
    locLongitude = json['loc_longitude'];
    locAddress = json['loc_address'];
    isDefault = json['is_default'];
  }
  num? id;
  num? userId;
  String? name;
  String? addressType;
  String? houseAddress;
  String? locality;
  String? landmark;
  String? locLatitude;
  String? locLongitude;
  String? locAddress;
  String? isDefault;
OrderAddress copyWith({  num? id,
  num? userId,
  String? name,
  String? addressType,
  String? houseAddress,
  String? locality,
  String? landmark,
  String? locLatitude,
  String? locLongitude,
  String? locAddress,
  String? isDefault,
}) => OrderAddress(  id: id ?? this.id,
  userId: userId ?? this.userId,
  name: name ?? this.name,
  addressType: addressType ?? this.addressType,
  houseAddress: houseAddress ?? this.houseAddress,
  locality: locality ?? this.locality,
  landmark: landmark ?? this.landmark,
  locLatitude: locLatitude ?? this.locLatitude,
  locLongitude: locLongitude ?? this.locLongitude,
  locAddress: locAddress ?? this.locAddress,
  isDefault: isDefault ?? this.isDefault,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['name'] = name;
    map['address_type'] = addressType;
    map['house_address'] = houseAddress;
    map['locality'] = locality;
    map['landmark'] = landmark;
    map['loc_latitude'] = locLatitude;
    map['loc_longitude'] = locLongitude;
    map['loc_address'] = locAddress;
    map['is_default'] = isDefault;
    return map;
  }

}