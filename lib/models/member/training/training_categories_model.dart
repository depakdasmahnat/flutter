import 'dart:convert';

TrainingCategoriesModel trainingCategoriesModelFromJson(String str) =>
    TrainingCategoriesModel.fromJson(json.decode(str));

String trainingCategoriesModelToJson(TrainingCategoriesModel data) => json.encode(data.toJson());

class TrainingCategoriesModel {
  TrainingCategoriesModel({
    this.status,
    this.message,
    this.data,
  });

  TrainingCategoriesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TrainingCategoryData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<TrainingCategoryData>? data;

  TrainingCategoriesModel copyWith({
    bool? status,
    String? message,
    List<TrainingCategoryData>? data,
  }) =>
      TrainingCategoriesModel(
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

TrainingCategoryData dataFromJson(String str) => TrainingCategoryData.fromJson(json.decode(str));

String dataToJson(TrainingCategoryData data) => json.encode(data.toJson());

class TrainingCategoryData {
  TrainingCategoryData({
    this.id,
    this.subCategoryName,
    this.image,
  });

  TrainingCategoryData.fromJson(dynamic json) {
    id = json['id'];
    subCategoryName = json['sub_category_name'];
    image = json['image'];
  }

  num? id;
  String? subCategoryName;
  String? image;

  TrainingCategoryData copyWith({
    num? id,
    String? subCategoryName,
    String? image,
  }) =>
      TrainingCategoryData(
        id: id ?? this.id,
        subCategoryName: subCategoryName ?? this.subCategoryName,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sub_category_name'] = subCategoryName;
    map['image'] = image;
    return map;
  }
}
