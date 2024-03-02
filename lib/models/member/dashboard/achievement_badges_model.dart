import 'dart:convert';

AchievementBadgesModel achievementBadgesModelFromJson(String str) =>
    AchievementBadgesModel.fromJson(json.decode(str));

String achievementBadgesModelToJson(AchievementBadgesModel data) => json.encode(data.toJson());

class AchievementBadgesModel {
  AchievementBadgesModel({
    this.status,
    this.message,
    this.currentTarget,
    this.members,
    this.achievedBadges,
  });

  AchievementBadgesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    currentTarget = json['current_target'];
    members = json['members'];
    achievedBadges = json['achieved_badges'] != null ? json['achieved_badges'].cast<String>() : [];
  }

  bool? status;
  String? message;
  String? currentTarget;
  num? members;
  List<String>? achievedBadges;

  AchievementBadgesModel copyWith({
    bool? status,
    String? message,
    String? currentTarget,
    num? members,
    List<String>? achievedBadges,
  }) =>
      AchievementBadgesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        currentTarget: currentTarget ?? this.currentTarget,
        members: members ?? this.members,
        achievedBadges: achievedBadges ?? this.achievedBadges,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['current_target'] = currentTarget;
    map['members'] = members;
    map['achieved_badges'] = achievedBadges;
    return map;
  }
}
