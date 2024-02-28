import 'dart:convert';

ToDoModel toDoModelFromJson(String str) => ToDoModel.fromJson(json.decode(str));

String toDoModelToJson(ToDoModel data) => json.encode(data.toJson());

class ToDoModel {
  ToDoModel({
    this.status,
    this.message,
    this.data,
  });

  ToDoModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ToDoData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  ToDoData? data;

  ToDoModel copyWith({
    bool? status,
    String? message,
    ToDoData? data,
  }) =>
      ToDoModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

ToDoData dataFromJson(String str) => ToDoData.fromJson(json.decode(str));

String dataToJson(ToDoData data) => json.encode(data.toJson());

class ToDoData {
  ToDoData({
    this.myPendingTarget,
    this.mySalesTarget,
    this.myAchievedTarget,
    this.teamPendingTarget,
    this.teamSalesTarget,
    this.teamAchievedTarget,
    this.chapterNumber,
    this.trainingPerc,
    this.events,
    this.demoScheduled,
    this.invitationCall,
    this.followUp,
  });

  ToDoData.fromJson(dynamic json) {
    myPendingTarget = json['my_pending_target'];
    mySalesTarget = json['my_sales_target'];
    myAchievedTarget = json['my_achieved_target'];
    teamPendingTarget = json['team_pending_target'];
    teamSalesTarget = json['team_sales_target'];
    teamAchievedTarget = json['team_achieved_target'];
    chapterNumber = json['chapter_number'];
    trainingPerc = json['training_perc'];
    events = json['events'];
    demoScheduled = json['demo_scheduled'];
    invitationCall = json['invitation_call'];
    followUp = json['follow_up'];
  }

  num? myPendingTarget;
  num? mySalesTarget;
  num? myAchievedTarget;
  num? teamPendingTarget;
  num? teamSalesTarget;
  num? teamAchievedTarget;
  String? chapterNumber;
  String? trainingPerc;
  num? events;
  num? demoScheduled;
  num? invitationCall;
  num? followUp;

  ToDoData copyWith({
    num? myPendingTarget,
    num? mySalesTarget,
    num? myAchievedTarget,
    num? teamPendingTarget,
    num? teamSalesTarget,
    num? teamAchievedTarget,
    String? chapterNumber,
    String? trainingPerc,
    num? events,
    num? demoScheduled,
    num? invitationCall,
    num? follow_up,
  }) =>
      ToDoData(
        myPendingTarget: myPendingTarget ?? this.myPendingTarget,
        mySalesTarget: mySalesTarget ?? this.mySalesTarget,
        myAchievedTarget: myAchievedTarget ?? this.myAchievedTarget,
        teamPendingTarget: teamPendingTarget ?? this.teamPendingTarget,
        teamSalesTarget: teamSalesTarget ?? this.teamSalesTarget,
        teamAchievedTarget: teamAchievedTarget ?? this.teamAchievedTarget,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        trainingPerc: trainingPerc ?? this.trainingPerc,
        events: events ?? this.events,
        demoScheduled: demoScheduled ?? this.demoScheduled,
        invitationCall: invitationCall ?? this.invitationCall,
        followUp: follow_up ?? this.followUp,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['my_pending_target'] = myPendingTarget;
    map['my_sales_target'] = mySalesTarget;
    map['my_achieved_target'] = myAchievedTarget;
    map['team_pending_target'] = teamPendingTarget;
    map['team_sales_target'] = teamSalesTarget;
    map['team_achieved_target'] = teamAchievedTarget;
    map['chapter_number'] = chapterNumber;
    map['training_perc'] = trainingPerc;
    map['events'] = events;
    map['demo_scheduled'] = demoScheduled;
    map['invitation_call'] = invitationCall;
    map['follow_up'] = followUp;
    return map;
  }
}
