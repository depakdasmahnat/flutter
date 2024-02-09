import 'dart:convert';

import '../dashboard/producer_details_model.dart';
import '../partner/setup/timeslots_model.dart';

CartItemsModel cartItemsModelFromJson(String str) => CartItemsModel.fromJson(json.decode(str));

String cartItemsModelToJson(CartItemsModel data) => json.encode(data.toJson());

class CartItemsModel {
  CartItemsModel({
    this.status,
    this.message,
    this.data,
  });

  CartItemsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CartItemsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<CartItemsData>? data;

  CartItemsModel copyWith({
    bool? status,
    String? message,
    List<CartItemsData>? data,
  }) =>
      CartItemsModel(
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

CartItemsData dataFromJson(String str) => CartItemsData.fromJson(json.decode(str));

String dataToJson(CartItemsData data) => json.encode(data.toJson());

class CartItemsData {
  CartItemsData({
    this.partnerId,
    this.partnerName,
    this.eachPersonAmount,
    this.isFreeSelfPicking,
    this.path,
    this.profilePhoto,
    this.partnerAddress,
    this.orderType,
    this.orderTypes,
    this.selectedOrderMethod,
    this.selectedTimeSlot,
    this.serviceTypes,
    this.products,
  });

  CartItemsData.fromJson(dynamic json) {
    partnerId = json['partner_id'];
    partnerName = json['partner_name'];
    eachPersonAmount = json['each_person_amount'];
    isFreeSelfPicking = json['is_free_self_picking'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    partnerAddress = json['partner_address'];
    orderType = json['order_type'];
    orderTypes = json['order_types'] != null ? json['order_types'].cast<String>() : [];
    selectedOrderMethod = json['selectedOrderMethod'];
    selectedTimeSlot = json['selectedTimeSlot'];
    if (json['service_types'] != null) {
      serviceTypes = [];
      json['service_types'].forEach((v) {
        serviceTypes?.add(ProducerServiceTypes.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProducerProducts.fromJson(v));
      });
    }
  }

  num? partnerId;
  String? partnerName;
  num? eachPersonAmount;
  String? isFreeSelfPicking;
  String? path;
  String? profilePhoto;
  String? partnerAddress;
  String? orderType;
  List<String>? orderTypes;
  String? selectedOrderMethod;
  TimeSlotsData? selectedTimeSlot;
  List<ProducerServiceTypes>? serviceTypes;
  List<ProducerProducts>? products;

  CartItemsData copyWith({
    num? partnerId,
    String? partnerName,
    num? eachPersonAmount,
    String? isFreeSelfPicking,
    String? path,
    String? profilePhoto,
    String? partnerAddress,
    String? orderType,
    List<String>? orderTypes,
    String? selectedOrderMethod,
    TimeSlotsData? selectedTimeSlot,
    List<ProducerServiceTypes>? serviceTypes,
    List<ProducerProducts>? products,
  }) =>
      CartItemsData(
        partnerId: partnerId ?? this.partnerId,
        partnerName: partnerName ?? this.partnerName,
        eachPersonAmount: eachPersonAmount ?? this.eachPersonAmount,
        isFreeSelfPicking: isFreeSelfPicking ?? this.isFreeSelfPicking,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        partnerAddress: partnerAddress ?? this.partnerAddress,
        orderType: orderType ?? this.orderType,
        orderTypes: orderTypes ?? this?.orderTypes,
        serviceTypes: serviceTypes ?? this.serviceTypes,
        products: products ?? this.products,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partner_id'] = partnerId;

    map['partner_name'] = partnerName;
    map['each_person_amount'] = eachPersonAmount;
    map['is_free_self_picking'] = isFreeSelfPicking;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['partner_address'] = partnerAddress;
    map['order_type'] = orderType;
    map['order_types'] = orderTypes;
    map['selectedOrderMethod'] = selectedOrderMethod;
    map['selectedTimeSlot'] = selectedTimeSlot;
    if (serviceTypes != null) {
      map['service_types'] = serviceTypes?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
