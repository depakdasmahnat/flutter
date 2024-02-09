import 'dart:convert';

PaymentSummaryModel paymentSummaryModelFromJson(String str) => PaymentSummaryModel.fromJson(json.decode(str));

String paymentSummaryModelToJson(PaymentSummaryModel data) => json.encode(data.toJson());

class PaymentSummaryModel {
  PaymentSummaryModel({
    this.status,
    this.message,
    this.data,
  });

  PaymentSummaryModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PaymentSummaryData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PaymentSummaryData? data;

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

PaymentSummaryData dataFromJson(String str) => PaymentSummaryData.fromJson(json.decode(str));

String dataToJson(PaymentSummaryData data) => json.encode(data.toJson());

class PaymentSummaryData {
  PaymentSummaryData({
    this.subtotal,
    this.taxAmount,
    this.taxPercent,
    this.coins,
    this.totalCoinAmount,
    this.couponPrice,
    this.grandTotal,
    this.wonCoins,
    this.totalValidCoins,
  });

  PaymentSummaryData.fromJson(dynamic json) {
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    taxPercent = json['tax_percent'];
    coins = json['coins'];
    totalCoinAmount = json['total_coin_amount'];
    couponPrice = json['coupon_price'];
    grandTotal = json['grand_total'];
    wonCoins = json['won_coins'];
    totalValidCoins = json['total_valid_coins'];
  }

  num? subtotal;
  num? taxAmount;
  num? taxPercent;
  num? coins;
  num? totalCoinAmount;
  num? couponPrice;
  num? grandTotal;
  num? wonCoins;
  num? totalValidCoins;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subtotal'] = subtotal;
    map['tax_amount'] = taxAmount;
    map['tax_percent'] = taxPercent;
    map['coins'] = coins;
    map['total_coin_amount'] = totalCoinAmount;
    map['coupon_price'] = couponPrice;
    map['grand_total'] = grandTotal;
    map['won_coins'] = wonCoins;
    map['total_valid_coins'] = totalValidCoins;
    return map;
  }
}
