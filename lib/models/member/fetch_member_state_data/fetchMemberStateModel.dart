import 'dart:convert';
FetchMemberStateModel fetchMemberStateModelFromJson(String str) => FetchMemberStateModel.fromJson(json.decode(str));
String fetchMemberStateModelToJson(FetchMemberStateModel data) => json.encode(data.toJson());
class FetchMemberStateModel {
  FetchMemberStateModel({
      this.status, 
      this.message, 
      this.data,});

  FetchMemberStateModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.leadsAdded, 
      this.leadsClosed, 
      this.demoDone, 
      this.demoScheduled, 
      this.invitationCall, 
      this.hotLeads, 
      this.warmLeads, 
      this.coldLeads, 
      this.leadsConversion,});

  Data.fromJson(dynamic json) {
    leadsAdded = json['leads_added'];
    leadsClosed = json['leads_closed'];
    demoDone = json['demo_done'];
    demoScheduled = json['demoScheduled'];
    invitationCall = json['invitationCall'];
    hotLeads = json['hotLeads'];
    warmLeads = json['warmLeads'];
    coldLeads = json['coldLeads'];
    leadsConversion = json['leadsConversion'];
  }
  num? leadsAdded;
  num? leadsClosed;
  num? demoDone;
  num? demoScheduled;
  num? invitationCall;
  num? hotLeads;
  num? warmLeads;
  num? coldLeads;
  num? leadsConversion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leads_added'] = leadsAdded;
    map['leads_closed'] = leadsClosed;
    map['demo_done'] = demoDone;
    map['demoScheduled'] = demoScheduled;
    map['invitationCall'] = invitationCall;
    map['hotLeads'] = hotLeads;
    map['warmLeads'] = warmLeads;
    map['coldLeads'] = coldLeads;
    map['leadsConversion'] = leadsConversion;
    return map;
  }

}