import 'dart:convert';

PaymentIntentModel paymentIntentModelFromJson(String str) => PaymentIntentModel.fromJson(json.decode(str));

String paymentIntentModelToJson(PaymentIntentModel data) => json.encode(data.toJson());

class PaymentIntentModel {
  PaymentIntentModel({
    this.status,
    this.message,
    this.data,
  });

  PaymentIntentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PaymentIntentData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PaymentIntentData? data;

  PaymentIntentModel copyWith({
    bool? status,
    String? message,
    PaymentIntentData? data,
  }) =>
      PaymentIntentModel(
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

PaymentIntentData dataFromJson(String str) => PaymentIntentData.fromJson(json.decode(str));

String dataToJson(PaymentIntentData data) => json.encode(data.toJson());

class PaymentIntentData {
  PaymentIntentData({
    this.paymentIntent,
    this.amount,
    this.amountReceived,
    this.currency,
    this.clientSecret,
  });

  PaymentIntentData.fromJson(dynamic json) {
    paymentIntent = json['payment_intent'];
    amount = json['amount'];
    amountReceived = json['amount_received'];
    currency = json['currency'];
    clientSecret = json['client_secret'];
  }

  String? paymentIntent;
  num? amount;
  num? amountReceived;
  String? currency;
  String? clientSecret;

  PaymentIntentData copyWith({
    String? paymentIntent,
    num? amount,
    num? amountReceived,
    String? currency,
    String? clientSecret,
  }) =>
      PaymentIntentData(
        paymentIntent: paymentIntent ?? this.paymentIntent,
        amount: amount ?? this.amount,
        amountReceived: amountReceived ?? this.amountReceived,
        currency: currency ?? this.currency,
        clientSecret: clientSecret ?? this.clientSecret,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_intent'] = paymentIntent;
    map['amount'] = amount;
    map['amount_received'] = amountReceived;
    map['currency'] = currency;
    map['client_secret'] = clientSecret;
    return map;
  }
}
