import 'dart:convert';
CheckTimeLinesStatus checkTimeLinesStatusFromJson(String str) => CheckTimeLinesStatus.fromJson(json.decode(str));
String checkTimeLinesStatusToJson(CheckTimeLinesStatus data) => json.encode(data.toJson());
class CheckTimeLinesStatus {
  CheckTimeLinesStatus({
      this.status, 
      this.message, 
      this.data, 
      this.orderTypes,});

  CheckTimeLinesStatus.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    orderTypes = json['order_type'] != null ? json['order_type'].cast<String>() : [];
  }
  bool? status;
  String? message;
  dynamic data;
  List<String>? orderTypes;
CheckTimeLinesStatus copyWith({  bool? status,
  String? message,
  dynamic data,
  List<String>? orderTypes,
}) => CheckTimeLinesStatus(  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
  orderTypes: orderTypes ?? this.orderTypes,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    map['order_type'] = orderTypes;
    return map;
  }

}