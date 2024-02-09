import 'dart:convert';
DownloadInvoiceModel downloadInvoiceModelFromJson(String str) => DownloadInvoiceModel.fromJson(json.decode(str));
String downloadInvoiceModelToJson(DownloadInvoiceModel data) => json.encode(data.toJson());
class DownloadInvoiceModel {
  DownloadInvoiceModel({
      this.status, 
      this.message, 
      this.data,});

  DownloadInvoiceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;
DownloadInvoiceModel copyWith({  bool? status,
  String? message,
  Data? data,
}) => DownloadInvoiceModel(  status: status ?? this.status,
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.title, 
      this.link,});

  Data.fromJson(dynamic json) {
    title = json['title'];
    link = json['link'];
  }
  String? title;
  String? link;
Data copyWith({  String? title,
  String? link,
}) => Data(  title: title ?? this.title,
  link: link ?? this.link,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['link'] = link;
    return map;
  }

}