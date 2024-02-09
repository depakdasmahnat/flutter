import 'dart:convert';

import 'my_service_model.dart';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  ServicesModel({
    this.status,
    this.message,
    this.showContacts,
    this.showEmail,
    this.data,
  });

  ServicesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    showContacts = json['show_contacts'];
    showEmail = json['show_email'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ServicesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  String? showContacts;
  String? showEmail;
  List<ServicesData>? data;

  ServicesModel copyWith({
    bool? status,
    String? message,
    String? showContacts,
    String? show_email,
    List<ServicesData>? data,
  }) =>
      ServicesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        showContacts: showContacts ?? this.showContacts,
        showEmail: show_email ?? this.showEmail,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['show_contacts'] = showContacts;
    map['show_email'] = showEmail;
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
    this.showContacts,
    this.subcategories,
  });

  ServicesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    showContacts = json['show_contacts'];
    if (json['subcategories'] != null) {
      subcategories = [];
      json['subcategories'].forEach((v) {
        subcategories?.add(Subcategory.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  String? showContacts;
  List<Subcategory>? subcategories;

  ServicesData copyWith({
    num? id,
    String? name,
    String? showContacts,
    List<Subcategory>? subcategories,
  }) =>
      ServicesData(
        id: id ?? this.id,
        name: name ?? this.name,
        showContacts: showContacts ?? this.showContacts,
        subcategories: subcategories ?? this.subcategories,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['show_contacts'] = showContacts;
    if (subcategories != null) {
      map['subcategories'] = subcategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Subcategory subcategoriesFromJson(String str) => Subcategory.fromJson(json.decode(str));

String subcategoriesToJson(Subcategory data) => json.encode(data.toJson());

class Subcategory {
  Subcategory({
    this.id,
    this.categoryId,
    this.name,
    this.selected,
    this.amount,
    this.unit,
    this.about,
    this.isActive,
    this.serviceImages,
  });

  Subcategory.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    selected = json['selected'];
    amount = json['amount'];
    unit = json['unit'];
    about = json['about'];
    isActive = json['isActive'];
    if (json['service_images'] != null) {
      serviceImages = [];
      json['service_images'].forEach((v) {
        serviceImages?.add(ServiceImages.fromJson(v));
      });
    }
  }

  num? id;
  num? categoryId;
  String? name;
  bool? selected;
  num? amount;
  String? unit;
  String? about;
  bool? isActive;
  List<ServiceImages>? serviceImages;

  Subcategory copyWith({
    num? id,
    num? categoryId,
    String? name,
    bool? selected,
    num? amount,
    String? unit,
    String? about,
    bool? isActive,
    List<ServiceImages>? serviceImages,
  }) =>
      Subcategory(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        selected: selected ?? this.selected,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        about: about ?? this.about,
        isActive: isActive ?? this.isActive,
        serviceImages: serviceImages ?? this.serviceImages,
      );



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['name'] = name;
    map['selected'] = selected;
    map['selected'] = selected;
    map['amount'] = amount;
    map['unit'] = unit;
    map['about'] = about;
    map['isActive'] = isActive;
    if (serviceImages != null) {
      map['service_images'] = serviceImages?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
