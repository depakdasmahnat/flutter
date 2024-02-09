import 'dart:convert';

CreateOrderIdModel createOrderIdModelFromJson(String str) => CreateOrderIdModel.fromJson(json.decode(str));

String createOrderIdModelToJson(CreateOrderIdModel data) => json.encode(data.toJson());

class CreateOrderIdModel {
  CreateOrderIdModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<CreateOrderIdData>? data;

  factory CreateOrderIdModel.fromJson(Map<String, dynamic> json) => CreateOrderIdModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<CreateOrderIdData>.from(json["data"].map((x) => CreateOrderIdData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CreateOrderIdData {
  CreateOrderIdData({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.offerId,
    this.status,
    this.attempts,
    this.notes,
    this.createdAt,
  });

  String? id;
  String? entity;
  int? amount;
  int? amountPaid;
  int? amountDue;
  String? currency;
  String? receipt;
  dynamic offerId;
  String? status;
  int? attempts;
  List<dynamic>? notes;
  int? createdAt;

  factory CreateOrderIdData.fromJson(Map<String, dynamic> json) => CreateOrderIdData(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        amountDue: json["amount_due"],
        currency: json["currency"],
        receipt: json["receipt"],
        offerId: json["offer_id"],
        status: json["status"],
        attempts: json["attempts"],
        notes: json["notes"] == null ? null : List<dynamic>.from(json["notes"].map((x) => x)),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "currency": currency,
        "receipt": receipt,
        "offer_id": offerId,
        "status": status,
        "attempts": attempts,
        "notes": notes == null ? null : List<dynamic>.from(notes!.map((x) => x)),
        "created_at": createdAt,
      };
}
