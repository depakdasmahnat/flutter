import 'dart:convert';

PartnerOrderDetailModel partnerOrderDetailModelFromJson(String str) =>
    PartnerOrderDetailModel.fromJson(json.decode(str));

String partnerOrderDetailModelToJson(PartnerOrderDetailModel data) => json.encode(data.toJson());

class PartnerOrderDetailModel {
  PartnerOrderDetailModel({
    this.status,
    this.message,
    this.data,
  });

  PartnerOrderDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerOrderDetailData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerOrderDetailData? data;

  PartnerOrderDetailModel copyWith({
    bool? status,
    String? message,
    PartnerOrderDetailData? data,
  }) =>
      PartnerOrderDetailModel(
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

PartnerOrderDetailData dataFromJson(String str) => PartnerOrderDetailData.fromJson(json.decode(str));

String dataToJson(PartnerOrderDetailData data) => json.encode(data.toJson());

class PartnerOrderDetailData {
  PartnerOrderDetailData({
    this.id,
    this.type,
    this.partnerId,
    this.userId,
    this.orderId,
    this.orderNumber,
    this.orderType,
    this.couponApplied,
    this.couponId,
    this.couponPrice,
    this.coinsApplied,
    this.coinsAmount,
    this.actualAmount,
    this.subtotal,
    this.taxAmount,
    this.paymentMethod,
    this.taxPercent,
    this.discount,
    this.totalAmount,
    this.paidAmount,
    this.orderStatus,
    this.createdAt,
    this.userLatitude,
    this.userLongitude,
    this.noOfPersons,
    this.eachPersonAmount,
    this.totalPersonAmount,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryAddress,
    this.userName,
    this.userEmail,
    this.userAddress,
    this.userMobile,
    this.path,
    this.profilePhoto,
    this.timeslotId,
    this.partnerRating,
    this.partnerReviews,
    this.timeslotDay,
    this.fromTime,
    this.toTime,
    this.timeslotName,
    this.datetime,
    this.reviewAdded,
    this.ratings,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.comment,
    this.products,
  });

  PartnerOrderDetailData.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    partnerId = json['partner_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    orderType = json['order_type'];
    couponApplied = json['coupon_applied'];
    couponId = json['coupon_id'];
    couponPrice = json['coupon_price'];
    coinsApplied = json['coins_applied'];
    coinsAmount = json['coins_amount'];
    actualAmount = json['actual_amount'];
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    paymentMethod = json['payment_method'];
    taxPercent = json['tax_percent'];
    discount = json['discount'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
    noOfPersons = json['no_of_persons'];
    eachPersonAmount = json['each_person_amount'];
    totalPersonAmount = json['total_person_amount'];
    deliveryLatitude = json['delivery_latitude'];
    deliveryLongitude = json['delivery_longitude'];
    deliveryAddress = json['delivery_address'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userAddress = json['user_address'];
    userMobile = json['user_mobile'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    timeslotId = json['timeslot_id'];
    partnerRating = json['partner_rating'];
    partnerReviews = json['partner_reviews'];
    timeslotDay = json['timeslot_day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timeslotName = json['timeslot_name'];
    datetime = json['datetime'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    comment = json['comment'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(PartnerOrderDetailProducts.fromJson(v));
      });
    }
  }

  num? id;
  String? type;
  num? partnerId;
  num? userId;
  num? orderId;
  String? orderNumber;
  String? orderType;
  String? couponApplied;
  dynamic couponId;
  num? couponPrice;
  String? coinsApplied;
  num? coinsAmount;
  num? actualAmount;
  num? subtotal;
  num? taxAmount;
  String? paymentMethod;
  num? taxPercent;
  num? discount;
  num? totalAmount;
  num? paidAmount;
  String? orderStatus;
  String? createdAt;
  String? userLatitude;
  String? userLongitude;
  num? noOfPersons;
  num? eachPersonAmount;
  num? totalPersonAmount;
  dynamic deliveryLatitude;
  dynamic deliveryLongitude;
  dynamic deliveryAddress;
  String? userName;
  String? userEmail;
  String? userAddress;
  String? userMobile;
  dynamic path;
  dynamic profilePhoto;
  num? timeslotId;
  num? partnerRating;
  num? partnerReviews;
  String? timeslotDay;
  String? fromTime;
  String? toTime;
  String? timeslotName;
  String? datetime;
  bool? reviewAdded;
  num? ratings;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  String? comment;
  List<PartnerOrderDetailProducts>? products;

  PartnerOrderDetailData copyWith({
    num? id,
    String? type,
    num? partnerId,
    num? userId,
    num? orderId,
    String? orderNumber,
    String? orderType,
    String? couponApplied,
    dynamic couponId,
    num? couponPrice,
    String? coinsApplied,
    num? coinsAmount,
    num? actualAmount,
    num? subtotal,
    num? taxAmount,
    String? paymentMethod,
    num? taxPercent,
    num? discount,
    num? totalAmount,
    num? paid_amount,
    String? orderStatus,
    String? createdAt,
    String? userLatitude,
    String? userLongitude,
    num? noOfPersons,
    num? eachPersonAmount,
    num? totalPersonAmount,
    dynamic deliveryLatitude,
    dynamic deliveryLongitude,
    dynamic deliveryAddress,
    String? userName,
    String? userEmail,
    String? user_address,
    String? userMobile,
    dynamic path,
    dynamic profilePhoto,
    num? timeslotId,
    num? partnerRating,
    num? partnerReviews,
    String? timeslotDay,
    String? fromTime,
    String? toTime,
    String? timeslotName,
    String? datetime,
    bool? reviewAdded,
    num? ratings,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
    String? comment,
    List<PartnerOrderDetailProducts>? products,
  }) =>
      PartnerOrderDetailData(
        id: id ?? this.id,
        type: type ?? this.type,
        partnerId: partnerId ?? this.partnerId,
        userId: userId ?? this.userId,
        orderId: orderId ?? this.orderId,
        orderNumber: orderNumber ?? this.orderNumber,
        orderType: orderType ?? this.orderType,
        couponApplied: couponApplied ?? this.couponApplied,
        couponId: couponId ?? this.couponId,
        couponPrice: couponPrice ?? this.couponPrice,
        coinsApplied: coinsApplied ?? this.coinsApplied,
        coinsAmount: coinsAmount ?? this.coinsAmount,
        actualAmount: actualAmount ?? this.actualAmount,
        subtotal: subtotal ?? this.subtotal,
        taxAmount: taxAmount ?? this.taxAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        taxPercent: taxPercent ?? this.taxPercent,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        paidAmount: paid_amount ?? this.paidAmount,
        orderStatus: orderStatus ?? this.orderStatus,
        createdAt: createdAt ?? this.createdAt,
        userLatitude: userLatitude ?? this.userLatitude,
        userLongitude: userLongitude ?? this.userLongitude,
        noOfPersons: noOfPersons ?? this.noOfPersons,
        eachPersonAmount: eachPersonAmount ?? this.eachPersonAmount,
        totalPersonAmount: totalPersonAmount ?? this.totalPersonAmount,
        deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
        deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        userAddress: user_address ?? this.userAddress,
        userMobile: userMobile ?? this.userMobile,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        timeslotId: timeslotId ?? this.timeslotId,
        partnerRating: partnerRating ?? this.partnerRating,
        partnerReviews: partnerReviews ?? this.partnerReviews,
        timeslotDay: timeslotDay ?? this.timeslotDay,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
        timeslotName: timeslotName ?? this.timeslotName,
        datetime: datetime ?? this.datetime,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        distanceNumber: distanceNumber ?? this.distanceNumber,
        distance: distance ?? this.distance,
        distanceLabel: distanceLabel ?? this.distanceLabel,
        comment: comment ?? this.comment,
        products: products ?? this.products,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['partner_id'] = partnerId;
    map['user_id'] = userId;
    map['order_id'] = orderId;
    map['order_number'] = orderNumber;
    map['order_type'] = orderType;
    map['coupon_applied'] = couponApplied;
    map['coupon_id'] = couponId;
    map['coupon_price'] = couponPrice;
    map['coins_applied'] = coinsApplied;
    map['coins_amount'] = coinsAmount;
    map['actual_amount'] = actualAmount;
    map['subtotal'] = subtotal;
    map['tax_amount'] = taxAmount;
    map['payment_method'] = paymentMethod;
    map['tax_percent'] = taxPercent;
    map['discount'] = discount;
    map['total_amount'] = totalAmount;
    map['paid_amount'] = paidAmount;
    map['order_status'] = orderStatus;
    map['created_at'] = createdAt;
    map['user_latitude'] = userLatitude;
    map['user_longitude'] = userLongitude;
    map['no_of_persons'] = noOfPersons;
    map['each_person_amount'] = eachPersonAmount;
    map['total_person_amount'] = totalPersonAmount;
    map['delivery_latitude'] = deliveryLatitude;
    map['delivery_longitude'] = deliveryLongitude;
    map['delivery_address'] = deliveryAddress;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['user_address'] = userAddress;
    map['user_mobile'] = userMobile;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['timeslot_id'] = timeslotId;
    map['partner_rating'] = partnerRating;
    map['partner_reviews'] = partnerReviews;
    map['timeslot_day'] = timeslotDay;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['timeslot_name'] = timeslotName;
    map['datetime'] = datetime;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    map['comment'] = comment;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

PartnerOrderDetailProducts productsFromJson(String str) =>
    PartnerOrderDetailProducts.fromJson(json.decode(str));

String productsToJson(PartnerOrderDetailProducts data) => json.encode(data.toJson());

class PartnerOrderDetailProducts {
  PartnerOrderDetailProducts({
    this.id,
    this.productName,
    this.image,
    this.path,
    this.quantity,
    this.mrpAmount,
    this.totalMrpAmount,
    this.regularAmount,
    this.totalRegularAmount,
    this.remarks,
    this.unitName,
  });

  PartnerOrderDetailProducts.fromJson(dynamic json) {
    id = json['id'];
    productName = json['product_name'];
    image = json['image'];
    path = json['path'];
    quantity = json['quantity'];
    mrpAmount = json['mrp_amount'];
    totalMrpAmount = json['total_mrp_amount'];
    regularAmount = json['regular_amount'];
    totalRegularAmount = json['total_regular_amount'];
    remarks = json['remarks'];
    unitName = json['unit_name'];
  }

  num? id;
  String? productName;
  String? image;
  String? path;
  num? quantity;
  num? mrpAmount;
  num? totalMrpAmount;
  num? regularAmount;
  num? totalRegularAmount;
  String? remarks;
  String? unitName;

  PartnerOrderDetailProducts copyWith({
    num? id,
    String? productName,
    String? image,
    String? path,
    num? quantity,
    num? mrpAmount,
    num? totalMrpAmount,
    num? regularAmount,
    num? totalRegularAmount,
    String? remarks,
    String? unitName,
  }) =>
      PartnerOrderDetailProducts(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        image: image ?? this.image,
        path: path ?? this.path,
        quantity: quantity ?? this.quantity,
        mrpAmount: mrpAmount ?? this.mrpAmount,
        totalMrpAmount: totalMrpAmount ?? this.totalMrpAmount,
        regularAmount: regularAmount ?? this.regularAmount,
        totalRegularAmount: totalRegularAmount ?? this.totalRegularAmount,
        remarks: remarks ?? this.remarks,
        unitName: unitName ?? this.unitName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_name'] = productName;
    map['image'] = image;
    map['path'] = path;
    map['quantity'] = quantity;
    map['mrp_amount'] = mrpAmount;
    map['total_mrp_amount'] = totalMrpAmount;
    map['regular_amount'] = regularAmount;
    map['total_regular_amount'] = totalRegularAmount;
    map['remarks'] = remarks;
    map['unit_name'] = unitName;
    return map;
  }
}
