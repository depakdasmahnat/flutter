class AppliedCoupon {
  AppliedCoupon({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  AppliedCouponData? data;

  factory AppliedCoupon.fromJson(Map<String, dynamic> json) => AppliedCoupon(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AppliedCouponData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class AppliedCouponData {
  AppliedCouponData({
    this.couponId,
    this.name,
    this.code,
    this.description,
    this.creatorId,
    this.creatorType,
    this.couponDiscountPrice,
  });

  int? couponId;
  String? name;
  String? code;
  String? description;
  num? creatorId;
  String? creatorType;
  dynamic couponDiscountPrice;

  factory AppliedCouponData.fromJson(Map<String, dynamic> json) => AppliedCouponData(
        couponId: json["coupon_id"],
        name: json["name"],
        description: json["description"],
        code: json["code"],
        creatorId: json["creator_id"],
        creatorType: json["creator_type"],
        couponDiscountPrice: json["coupon_discount_price"],
      );

  Map<String, dynamic> toJson() => {
        "coupon_id": couponId,
        "name": name,
        "description": description,
        "code": code,
        "creator_id": creatorId,
        "creator_type": creatorType,
        "coupon_discount_price": couponDiscountPrice,
      };
}
