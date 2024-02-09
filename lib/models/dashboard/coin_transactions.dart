import 'dart:convert';
CoinTransactionsModel coinTransactionsFromJson(String str) => CoinTransactionsModel.fromJson(json.decode(str));
String coinTransactionsToJson(CoinTransactionsModel data) => json.encode(data.toJson());
class CoinTransactionsModel {
  CoinTransactionsModel({
      this.success, 
      this.message, 
      this.totalPage, 
      this.data,});

  CoinTransactionsModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CoinTransactionsData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  num? totalPage;
  List<CoinTransactionsData>? data;
CoinTransactionsModel copyWith({  bool? success,
  String? message,
  num? totalPage,
  List<CoinTransactionsData>? data,
}) => CoinTransactionsModel(  success: success ?? this.success,
  message: message ?? this.message,
  totalPage: totalPage ?? this.totalPage,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['total_page'] = totalPage;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

CoinTransactionsData dataFromJson(String str) => CoinTransactionsData.fromJson(json.decode(str));
String dataToJson(CoinTransactionsData data) => json.encode(data.toJson());
class CoinTransactionsData {
  CoinTransactionsData({
      this.id, 
      this.transactionId, 
      this.orderId, 
      this.transactionDateTime, 
      this.paymentType, 
      this.transType, 
      this.amount, 
      this.paymentStatus, 
      this.remarks, 
      this.deletedAt, 
      this.transactionFormatDateTime, 
      this.transactionThrough, 
      this.transactionThroughType, 
      this.transactionThroughPhone, 
      this.title,});

  CoinTransactionsData.fromJson(dynamic json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    transactionDateTime = json['transaction_date_time'];
    paymentType = json['payment_type'];
    transType = json['trans_type'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    remarks = json['remarks'];
    deletedAt = json['deleted_at'];
    transactionFormatDateTime = json['transaction_format_date_time'];
    transactionThrough = json['transaction_through'];
    transactionThroughType = json['transaction_through_type'];
    transactionThroughPhone = json['transaction_through_phone'];
    title = json['title'];
  }
  num? id;
  String? transactionId;
  dynamic orderId;
  String? transactionDateTime;
  String? paymentType;
  String? transType;
  num? amount;
  String? paymentStatus;
  String? remarks;
  dynamic deletedAt;
  String? transactionFormatDateTime;
  String? transactionThrough;
  String? transactionThroughType;
  String? transactionThroughPhone;
  String? title;
CoinTransactionsData copyWith({  num? id,
  String? transactionId,
  dynamic orderId,
  String? transactionDateTime,
  String? paymentType,
  String? transType,
  num? amount,
  String? paymentStatus,
  String? remarks,
  dynamic deletedAt,
  String? transactionFormatDateTime,
  String? transactionThrough,
  String? transactionThroughType,
  String? transactionThroughPhone,
  String? title,
}) => CoinTransactionsData(  id: id ?? this.id,
  transactionId: transactionId ?? this.transactionId,
  orderId: orderId ?? this.orderId,
  transactionDateTime: transactionDateTime ?? this.transactionDateTime,
  paymentType: paymentType ?? this.paymentType,
  transType: transType ?? this.transType,
  amount: amount ?? this.amount,
  paymentStatus: paymentStatus ?? this.paymentStatus,
  remarks: remarks ?? this.remarks,
  deletedAt: deletedAt ?? this.deletedAt,
  transactionFormatDateTime: transactionFormatDateTime ?? this.transactionFormatDateTime,
  transactionThrough: transactionThrough ?? this.transactionThrough,
  transactionThroughType: transactionThroughType ?? this.transactionThroughType,
  transactionThroughPhone: transactionThroughPhone ?? this.transactionThroughPhone,
  title: title ?? this.title,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['transaction_id'] = transactionId;
    map['order_id'] = orderId;
    map['transaction_date_time'] = transactionDateTime;
    map['payment_type'] = paymentType;
    map['trans_type'] = transType;
    map['amount'] = amount;
    map['payment_status'] = paymentStatus;
    map['remarks'] = remarks;
    map['deleted_at'] = deletedAt;
    map['transaction_format_date_time'] = transactionFormatDateTime;
    map['transaction_through'] = transactionThrough;
    map['transaction_through_type'] = transactionThroughType;
    map['transaction_through_phone'] = transactionThroughPhone;
    map['title'] = title;
    return map;
  }

}