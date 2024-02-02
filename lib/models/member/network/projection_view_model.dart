import 'dart:convert';

ProjectionViewModel treeGraphModelFromJson(String str) => ProjectionViewModel.fromJson(json.decode(str));

String treeGraphModelToJson(ProjectionViewModel data) => json.encode(data.toJson());

class ProjectionViewModel {
  ProjectionViewModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  ProjectionViewModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['dataRecords'] != null ? DataRecords.fromJson(json['dataRecords']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProjectionViewData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<ProjectionViewData>? data;

  ProjectionViewModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<ProjectionViewData>? data,
  }) =>
      ProjectionViewModel(
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

ProjectionViewData dataFromJson(String str) => ProjectionViewData.fromJson(json.decode(str));

String dataToJson(ProjectionViewData data) => json.encode(data.toJson());

class ProjectionViewData {
  ProjectionViewData({
    this.id,
    this.name,
    this.profilePic,
    this.rank,
    this.section,
    this.level,
    this.parentId,
    this.sales,
    this.percentage,
    this.connectedMember,
  });

  ProjectionViewData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profilePic'];
    rank = json['rank'];
    section = json['section'];
    level = json['level'];
    parentId = json['parent_id'];
    sales = json['sales'];
    percentage = json['percentage'];
    if (json['connectedMember'] != null) {
      connectedMember = [];
      json['connectedMember'].forEach((v) {
        connectedMember?.add(ConnectedMember.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  String? profilePic;
  String? rank;
  String? section;
  num? level;
  num? parentId;
  num? sales;
  num? percentage;
  List<ConnectedMember>? connectedMember;

  ProjectionViewData copyWith({
    num? id,
    String? name,
    String? profilePic,
    String? rank,
    String? section,
    num? level,
    num? parentId,
    num? sales,
    num? percentage,
    List<ConnectedMember>? connectedMember,
  }) =>
      ProjectionViewData(
        id: id ?? this.id,
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        rank: rank ?? this.rank,
        section: section ?? this.section,
        level: level ?? this.level,
        parentId: parentId ?? this.parentId,
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
    map['section'] = section;
    map['level'] = level;

    map['parent_id'] = parentId;
    map['sales'] = sales;
    map['percentage'] = percentage;
    if (connectedMember != null) {
      map['connectedMember'] = connectedMember?.map((v) => v.toJson()).toList();
    }
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

ConnectedMember connectedMemberFromJson(String str) => ConnectedMember.fromJson(json.decode(str));

String connectedMemberToJson(ConnectedMember data) => json.encode(data.toJson());

class ConnectedMember {
  ConnectedMember({
    this.member,
    this.id,
  });

  ConnectedMember.fromJson(dynamic json) {
    member = json['member'];
    id = json['id'];
  }

  String? member;
  num? id;

  ConnectedMember copyWith({
    String? member,
    num? id,
  }) =>
      ConnectedMember(
        member: member ?? this.member,
        id: id ?? this.id,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['member'] = member;
    map['id'] = id;
    return map;
  }
}
