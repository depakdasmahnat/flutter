import 'dart:convert';
FetchDemoVideosAfter fetchDemoVideosAfterFromJson(String str) => FetchDemoVideosAfter.fromJson(json.decode(str));
String fetchDemoVideosAfterToJson(FetchDemoVideosAfter data) => json.encode(data.toJson());
class FetchDemoVideosAfter {
  FetchDemoVideosAfter({
      this.status, 
      this.message, 
      this.data,});

  FetchDemoVideosAfter.fromJson(dynamic json) {
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
      this.path, 
      this.file, 
      this.youtubeLink,
      this.type,
      this.videoLink,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    path = json['path'];
    file = json['file'];
    videoLink = json['video_link'];
    type = json['type'];
    youtubeLink = json['youtube_link'];
  }
  num? id;
  String? path;
  String? file;
  String? videoLink;
  String? type;
  String? youtubeLink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['path'] = path;
    map['file'] = file;
    map['video_link'] = videoLink;
    map['youtube_link'] = youtubeLink;
    map['type'] = type;
    return map;
  }

}