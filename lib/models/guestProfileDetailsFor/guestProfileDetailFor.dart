import 'dart:convert';
GuestProfileDetailFor guestProfileDetailForFromJson(String str) => GuestProfileDetailFor.fromJson(json.decode(str));
String guestProfileDetailForToJson(GuestProfileDetailFor data) => json.encode(data.toJson());
class GuestProfileDetailFor {
  GuestProfileDetailFor({
      this.status, 
      this.message, 
      this.data,});

  GuestProfileDetailFor.fromJson(dynamic json) {
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
      this.profilePhoto, 
      this.firstName, 
      this.lastName, 
      this.mobile, 
      this.address, 
      this.city, 
      this.state, 
      this.watchedVideosCount, 
      this.pendingVideosCount, 
      this.watchCount, 
      this.leadJourney, 
      this.watchedVideos,});

  Data.fromJson(dynamic json) {
    profilePhoto = json['profile_photo'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    watchedVideosCount = json['watched_videos_count'];
    pendingVideosCount = json['pending_videos_count'];
    watchCount = json['watch_count'];
    leadJourney = json['lead_journey'] != null ? LeadJourney.fromJson(json['lead_journey']) : null;
    if (json['watched_videos'] != null) {
      watchedVideos = [];
      json['watched_videos'].forEach((v) {
        watchedVideos?.add(WatchedVideos.fromJson(v));
      });
    }
  }
  String? profilePhoto;
  String? firstName;
  String? lastName;
  String? mobile;
  dynamic address;
  String? city;
  String? state;
  num? watchedVideosCount;
  num? pendingVideosCount;
  String? watchCount;
  LeadJourney? leadJourney;
  List<WatchedVideos>? watchedVideos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profile_photo'] = profilePhoto;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['watched_videos_count'] = watchedVideosCount;
    map['pending_videos_count'] = pendingVideosCount;
    map['watch_count'] = watchCount;
    if (leadJourney != null) {
      map['lead_journey'] = leadJourney?.toJson();
    }
    if (watchedVideos != null) {
      map['watched_videos'] = watchedVideos?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

WatchedVideos watchedVideosFromJson(String str) => WatchedVideos.fromJson(json.decode(str));
String watchedVideosToJson(WatchedVideos data) => json.encode(data.toJson());
class WatchedVideos {
  WatchedVideos({
      this.id, 
      this.title, 
      this.fileType, 
      this.path, 
      this.file, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.isActive, 
      this.demoStep,});

  WatchedVideos.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    fileType = json['file_type'];
    path = json['path'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isActive = json['is_active'];
    demoStep = json['demo_step'];
  }
  num? id;
  String? title;
  String? fileType;
  String? path;
  String? file;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? isActive;
  dynamic demoStep;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['file_type'] = fileType;
    map['path'] = path;
    map['file'] = file;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['is_active'] = isActive;
    map['demo_step'] = demoStep;
    return map;
  }

}

LeadJourney leadJourneyFromJson(String str) => LeadJourney.fromJson(json.decode(str));
String leadJourneyToJson(LeadJourney data) => json.encode(data.toJson());
class LeadJourney {
  LeadJourney({
      this.addedInNewList, 
      this.moveToInvitationCall, 
      this.businessDemoMeeting, 
      this.productDemoMeeting, 
      this.demoScheduled, 
      this.followUp,

      this.moveToClosing,});

  LeadJourney.fromJson(dynamic json) {
    addedInNewList = json['added_in_new_list'];
    moveToInvitationCall = json['move_to_invitation_call'];
    businessDemoMeeting = json['business_demo_meeting'];
    productDemoMeeting = json['product_demo_meeting'];
    demoScheduled = json['demo_scheduled'];
    moveToClosing = json['move_to_closing'];
    followUp = json['follow_up'];
  }
  String? addedInNewList;
  String? moveToInvitationCall;
  String? businessDemoMeeting;
  String? productDemoMeeting;
  String? demoScheduled;
  String? moveToClosing;
  String? followUp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['added_in_new_list'] = addedInNewList;
    map['move_to_invitation_call'] = moveToInvitationCall;
    map['business_demo_meeting'] = businessDemoMeeting;
    map['product_demo_meeting'] = productDemoMeeting;
    map['demo_scheduled'] = demoScheduled;
    map['move_to_closing'] = moveToClosing;
    map['follow_up'] = followUp;
    return map;
  }

}