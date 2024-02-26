import 'dart:convert';
GetPerformanceChart getPerformanceChartFromJson(String str) => GetPerformanceChart.fromJson(json.decode(str));
String getPerformanceChartToJson(GetPerformanceChart data) => json.encode(data.toJson());
class GetPerformanceChart {
  GetPerformanceChart({
      this.status, 
      this.message, 
      this.data,});

  GetPerformanceChart.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Data>? data;

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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.rankId, 
      this.indexes, 
      this.createdAt, 
      this.updatedAt, 
      this.isActive, 
      this.deletedAt,
      this.rankName,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    rankId = json['rank_id'];
    if (json['indexes'] != null) {
      indexes = [];
      json['indexes'].forEach((v) {
        indexes?.add(Indexes.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    rankName = json['rank_name'];
  }
  num? id;
  num? rankId;
  List<Indexes>? indexes;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  String? rankName;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rank_id'] = rankId;
    if (indexes != null) {
      map['indexes'] = indexes?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['rankName'] = rankName;
    return map;
  }

}

Indexes indexesFromJson(String str) => Indexes.fromJson(json.decode(str));
String indexesToJson(Indexes data) => json.encode(data.toJson());
class Indexes {
  Indexes({
      this.title, 
      this.value,});

  Indexes.fromJson(dynamic json) {
    title = json['title'];
    value = json['value'];
  }
  String? title;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['value'] = value;
    return map;
  }

}