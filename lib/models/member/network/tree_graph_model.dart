import 'dart:convert';

TreeGraphModel treeGraphModelFromJson(String str) => TreeGraphModel.fromJson(json.decode(str));

String treeGraphModelToJson(TreeGraphModel data) => json.encode(data.toJson());

class TreeGraphModel {
  TreeGraphModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  TreeGraphModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['dataRecords'] != null ? DataRecords.fromJson(json['dataRecords']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TreeGraphData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<TreeGraphData>? data;

  TreeGraphModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<TreeGraphData>? data,
  }) =>
      TreeGraphModel(
        status: status ?? this.status,
        message: message ?? this.message,
        dataRecords: dataRecords ?? this.dataRecords,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['dataRecords'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

TreeGraphData dataFromJson(String str) => TreeGraphData.fromJson(json.decode(str));

String dataToJson(TreeGraphData data) => json.encode(data.toJson());

class TreeGraphData {
  TreeGraphData({
    this.id,
    this.name,
    this.profilePic,
    this.rank,
    this.level,
    this.sales,
    this.percentage,
    this.connectedMember,
  });

  TreeGraphData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profilePic'];
    rank = json['rank'];
    level = json['level'];
    sales = json['sales'];
    percentage = json['percentage'];
    connectedMember = json['connectedMember'] != null ? json['connectedMember'].cast<num>() : [];
  }

  num? id;
  String? name;
  String? profilePic;
  String? rank;
  String? level;
  String? sales;
  String? percentage;
  List<num>? connectedMember;

  TreeGraphData copyWith({
    num? id,
    String? name,
    String? profilePic,
    String? rank,
    String? level,
    String? sales,
    String? percentage,
    List<num>? connectedMember,
  }) =>
      TreeGraphData(
        id: id ?? this.id,
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        rank: rank ?? this.rank,
        level: level ?? this.level,
        sales: sales ?? this.sales,
        percentage: percentage ?? this.percentage,
        connectedMember: connectedMember ?? this.connectedMember,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['profilePic'] = profilePic;
    map['rank'] = rank;
    map['level'] = level;
    map['sales'] = sales;
    map['percentage'] = percentage;
    map['connectedMember'] = connectedMember;
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
    totalPage = json['totalPage'];
    limit = json['limit'];
    page = json['page'];
  }

  num? totalPage;
  num? limit;
  num? page;

  DataRecords copyWith({
    num? totalPage,
    num? limit,
    num? page,
  }) =>
      DataRecords(
        totalPage: totalPage ?? this.totalPage,
        limit: limit ?? this.limit,
        page: page ?? this.page,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPage'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }
}
