import 'dart:convert';

PartnerDashBoardModel partnerDashBoardModelFromJson(String str) => PartnerDashBoardModel.fromJson(json.decode(str));

String partnerDashBoardModelToJson(PartnerDashBoardModel data) => json.encode(data.toJson());

class PartnerDashBoardModel {
  PartnerDashBoardModel({
    this.status,
    this.message,
    this.data,
  });

  PartnerDashBoardModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerDashBoardData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerDashBoardData? data;

  PartnerDashBoardModel copyWith({
    bool? status,
    String? message,
    PartnerDashBoardData? data,
  }) =>
      PartnerDashBoardModel(
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

PartnerDashBoardData dataFromJson(String str) => PartnerDashBoardData.fromJson(json.decode(str));

String dataToJson(PartnerDashBoardData data) => json.encode(data.toJson());

class PartnerDashBoardData {
  PartnerDashBoardData({
    this.newOrders,
    this.pending,
    this.completed,
    this.todaysOrders,
    this.todaysEarn,
    this.totalSettleled,
    this.todaysOrdersHike,
    this.todaysEarnHike,
    this.totalSettleledHike,
  });

  PartnerDashBoardData.fromJson(dynamic json) {
    newOrders = json['new_orders'];
    pending = json['pending'];
    completed = json['completed'];
    todaysOrders = json['todays_orders'];
    todaysEarn = json['todays_earn'];
    totalSettleled = json['total_settleled'];
    todaysOrdersHike = json['todays_orders_hike'];
    todaysEarnHike = json['todays_earn_hike'];
    totalSettleledHike = json['total_settleled_hike'];
  }

  num? newOrders;
  num? pending;
  num? completed;
  num? todaysOrders;
  num? todaysEarn;
  num? totalSettleled;
  num? todaysOrdersHike;
  num? todaysEarnHike;
  num? totalSettleledHike;

  PartnerDashBoardData copyWith({
    num? newOrders,
    num? pending,
    num? completed,
    num? todaysOrders,
    num? todaysEarn,
    num? totalSettleled,
    num? todaysOrdersHike,
    num? todaysEarnHike,
    num? totalSettleledHike,
  }) =>
      PartnerDashBoardData(
        newOrders: newOrders ?? this.newOrders,
        pending: pending ?? this.pending,
        completed: completed ?? this.completed,
        todaysOrders: todaysOrders ?? this.todaysOrders,
        todaysEarn: todaysEarn ?? this.todaysEarn,
        totalSettleled: totalSettleled ?? this.totalSettleled,
        todaysOrdersHike: todaysOrdersHike ?? this.todaysOrdersHike,
        todaysEarnHike: todaysEarnHike ?? this.todaysEarnHike,
        totalSettleledHike: totalSettleledHike ?? this.totalSettleledHike,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_orders'] = newOrders;
    map['pending'] = pending;
    map['completed'] = completed;
    map['todays_orders'] = todaysOrders;
    map['todays_earn'] = todaysEarn;
    map['total_settleled'] = totalSettleled;
    map['todays_orders_hike'] = todaysOrdersHike;
    map['todays_earn_hike'] = todaysEarnHike;
    map['total_settleled_hike'] = totalSettleledHike;
    return map;
  }
}
