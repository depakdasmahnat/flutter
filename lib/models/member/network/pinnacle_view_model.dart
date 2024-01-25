import 'dart:convert';
PinnacleViewModel pinnacleViewModelFromJson(String str) => PinnacleViewModel.fromJson(json.decode(str));
String pinnacleViewModelToJson(PinnacleViewModel data) => json.encode(data.toJson());
class PinnacleViewModel {
  PinnacleViewModel({
      this.status, 
      this.message, 
      this.data,});

  PinnacleViewModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PinnacleViewData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<PinnacleViewData>? data;
PinnacleViewModel copyWith({  bool? status,
  String? message,
  List<PinnacleViewData>? data,
}) => PinnacleViewModel(  status: status ?? this.status,
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

PinnacleViewData dataFromJson(String str) => PinnacleViewData.fromJson(json.decode(str));
String dataToJson(PinnacleViewData data) => json.encode(data.toJson());
class PinnacleViewData {
  PinnacleViewData({
      this.id, 
      this.name, 
      this.profilePic, 
      this.rank, 
      this.level, 
      this.sales, 
      this.percentage, 
      this.connectedMember,});

  PinnacleViewData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profilePic'];
    rank = json['rank'];
    level = json['level'];
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
  String? level;
  String? sales;
  String? percentage;
  List<ConnectedMember>? connectedMember;
PinnacleViewData copyWith({  num? id,
  String? name,
  String? profilePic,
  String? rank,
  String? level,
  String? sales,
  String? percentage,
  List<ConnectedMember>? connectedMember,
}) => PinnacleViewData(  id: id ?? this.id,
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
    if (connectedMember != null) {
      map['connectedMember'] = connectedMember?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

ConnectedMember connectedMemberFromJson(String str) => ConnectedMember.fromJson(json.decode(str));
String connectedMemberToJson(ConnectedMember data) => json.encode(data.toJson());
class ConnectedMember {
  ConnectedMember({
      this.member, 
      this.id,});

  ConnectedMember.fromJson(dynamic json) {
    member = json['member'];
    id = json['id'];
  }
  String? member;
  num? id;
ConnectedMember copyWith({  String? member,
  num? id,
}) => ConnectedMember(  member: member ?? this.member,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['member'] = member;
    map['id'] = id;
    return map;
  }

}